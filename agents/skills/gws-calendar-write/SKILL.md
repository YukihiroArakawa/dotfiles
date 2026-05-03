---
name: gws-calendar-write
description: Google Calendar の予定を `gws` で作成または編集する。ユーザーが「予定を入れて」「この予定の時間を変えて」「Family カレンダーに追加して」のように Google Calendar への書き込みを求めたときに使う。削除は扱わず、単発または少数件の安全な追加・更新に限定する。
---

# GWS Calendar Write

`gws` を使って Google Calendar の予定を安全に追加・編集する。削除、全件更新、大量一括変更は扱わない。

## 入力

- 必須: 作成か編集か
- 必須: タイトル
- 必須: 日時
- 任意: 対象カレンダー名または ID。未指定なら `primary`
- 任意: 場所、説明、Meet URL、終日フラグ、通知

相対日付が含まれる場合は、そのまま使わず具体日付に正規化する。日本時間の会話では `Asia/Tokyo` を前提にし、回答では `2026-05-12 11:00-12:00` のように絶対日時で確認する。

## ワークフロー

### 1. 依頼を構造化する

- 作成か編集かを確定する
- 日時を RFC3339 か終日イベント用の日付に落とす
- カレンダー指定が曖昧なら `primary` / `Family` などの候補を確認する

必要な形式:

- 時刻あり: `2026-05-12T11:00:00+09:00`
- 終日: `2026-05-12`

### 2. 対象カレンダーを特定する

まずカレンダー一覧を確認する。

```bash
gws calendar calendarList list --params '{"minAccessRole":"reader"}'
```

ユーザーが `Family` のような表示名だけ指定した場合は、一覧から ID に解決してから続行する。よく使う例:

- `primary`: `yukiburos@gmail.com`
- `Family`: `family...@group.calendar.google.com`

### 3. 既存予定を確認する

編集時はいきなり `patch` しない。候補を絞ってから対象イベントを 1 件に特定する。

```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2026-05-01T00:00:00+09:00","timeMax":"2026-05-31T23:59:59+09:00","singleEvents":true,"orderBy":"startTime","q":"PayPay"}'
gws calendar events get --params '{"calendarId":"primary","eventId":"<event-id>"}'
```

同名イベントが複数ある場合は、時刻・場所・説明を見て 1 件に絞る。1 件に絞れないなら勝手に更新しない。

### 4. 予定を作成する

新規作成は `events insert` を使う。`calendarId` は `--params`、イベント本体は `--json` に渡す。

```bash
gws calendar events insert \
  --params '{"calendarId":"primary"}' \
  --json '{"summary":"PayPayカード面接","start":{"dateTime":"2026-05-12T11:00:00+09:00","timeZone":"Asia/Tokyo"},"end":{"dateTime":"2026-05-12T12:00:00+09:00","timeZone":"Asia/Tokyo"},"location":"https://meet.google.com/fyt-tvou-nni"}'
```

### 5. 予定を編集する

編集は `events patch` を使う。`events update` は未指定フィールドを落としやすいので使わない。

```bash
gws calendar events patch \
  --params '{"calendarId":"primary","eventId":"<event-id>"}' \
  --json '{"start":{"dateTime":"2026-05-12T12:00:00+09:00","timeZone":"Asia/Tokyo"},"end":{"dateTime":"2026-05-12T13:00:00+09:00","timeZone":"Asia/Tokyo"}}'
```

変更しないフィールドは送らない。説明文の一部変更などで既存値が必要なら、先に `events get` で取得してから組み立てる。

### 6. 結果を確認する

作成・編集後は応答から以下を確認して簡潔に伝える。

- カレンダー名
- タイトル
- 確定した日時
- 場所
- イベント ID または `htmlLink`

## ルール

- 削除は行わない。削除依頼が来たらこのスキルの対象外として扱う
- 大量件数の更新は行わない。少数件に限定する
- 編集時は必ず対象イベントを特定してから `patch` する
- 相対日付のまま実行しない。回答では絶対日時を明記する
- カレンダー指定がない場合だけ `primary` を既定にする
- 予定の説明にメール全文を無加工で貼りすぎない。必要部分だけ要約する

## 参照

コマンド雛形と JSON 例は [references/commands.md](references/commands.md) を読む。
