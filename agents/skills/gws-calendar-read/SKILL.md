---
name: gws-calendar-read
description: Google Calendar の予定を `gws` で調べる。ユーザーが「今日の予定を見て」「来週の Family カレンダーを確認して」「primary にこの名前の予定があるか調べて」のように、`primary` や `Family` の予定の一覧・検索・詳細確認を求めたときに使う。書き込みや削除は行わず、少数件の read-only な確認に限定する。
---

# GWS Calendar Read

`gws` を使って Google Calendar の予定を安全に確認する。対象は `primary` と `Family` を中心にした予定の一覧、検索、詳細確認で、作成・更新・削除は行わない。

## 入力

- 必須: 調べたい内容
- 任意: 対象カレンダー名または ID。未指定なら `primary`
- 任意: 期間
- 任意: タイトルや説明の検索語
- 任意: 詳細確認したいイベント ID

相対日付はそのまま使わず、必ず具体日付に正規化する。日本時間の会話では `Asia/Tokyo` を前提にし、回答では `2026-05-12 11:00-12:00` のように絶対日時で示す。

## ワークフロー

### 1. 依頼を構造化する

- 一覧確認か、検索か、詳細取得かを確定する
- 期間を RFC3339 の `timeMin` / `timeMax` に落とす
- カレンダー指定がなければ `primary` を既定にする
- 検索語やイベント ID があれば保持する

依頼が曖昧なら、勝手に広い期間を読まない。例えば「予定を見て」だけなら、対象日やカレンダーを確認する。

### 2. 対象カレンダーを特定する

まずカレンダー一覧を確認する。

```bash
gws calendar calendarList list --params '{"minAccessRole":"reader"}'
```

表示名だけ指定された場合は、一覧から ID に解決してから続行する。`Family` は固定のメールアドレスだと決め打ちせず、毎回一覧から確認する。

### 3. 予定を一覧または検索する

期間がある場合は `events list` を使う。展開後の予定を時系列で見たいので `singleEvents: true` と `orderBy: "startTime"` を付ける。

```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2026-05-01T00:00:00+09:00","timeMax":"2026-05-01T23:59:59+09:00","singleEvents":true,"orderBy":"startTime"}'
```

タイトルや説明の絞り込みが必要なら `q` を追加する。

```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2026-05-01T00:00:00+09:00","timeMax":"2026-05-31T23:59:59+09:00","singleEvents":true,"orderBy":"startTime","q":"面接"}'
```

### 4. 必要なら詳細を取得する

候補が複数あり、場所や説明まで見て判定したい場合は `events get` を使う。

```bash
gws calendar events get --params '{"calendarId":"primary","eventId":"<event-id>"}'
```

イベント ID が最初から指定されているときも同じく `get` を使う。

### 5. 結果を整理して返す

結果は以下を優先して簡潔に返す。

- カレンダー名
- タイトル
- 日時
- 場所
- ステータス
- イベント ID または `htmlLink`

一覧が 0 件なら、その期間とカレンダーで該当なしと明記する。件数が多いときは先頭数件を要約し、必要なら追加条件を聞く。

## ルール

- 書き込み系コマンドは使わない。`insert`、`patch`、`update`、`delete` は対象外
- 相対日付のまま実行しない。回答では絶対日時を明記する
- カレンダー指定がない場合だけ `primary` を既定にする
- `Family` は表示名から都度 ID に解決する
- 曖昧な依頼で広い期間を読まない。必要なら期間を確認する
- 詳細確認が不要なら `get` を乱用せず、まず `list` で絞る

## 参照

コマンド雛形と検索例は [references/commands.md](references/commands.md) を読む。
