# gws Calendar 読み取りコマンド例

## カレンダー一覧

`primary` や `Family` の ID 解決に使う。

```bash
gws calendar calendarList list --params '{"minAccessRole":"reader"}'
```

## 1 日の予定一覧

`primary` の当日予定を時系列で見る例。

```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2026-05-04T00:00:00+09:00","timeMax":"2026-05-04T23:59:59+09:00","singleEvents":true,"orderBy":"startTime"}'
```

## カレンダー未指定時の既定動作

未指定なら `primary` と `Family` の両方を読む。まず `calendarList` で `Family` の ID を確認し、その後それぞれに対して `events list` を実行する。

```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2026-05-04T00:00:00+09:00","timeMax":"2026-05-04T23:59:59+09:00","singleEvents":true,"orderBy":"startTime"}'
gws calendar events list --params '{"calendarId":"family10527717505002077024@group.calendar.google.com","timeMin":"2026-05-04T00:00:00+09:00","timeMax":"2026-05-04T23:59:59+09:00","singleEvents":true,"orderBy":"startTime"}'
```

## Family の週次確認

`Family` の ID は事前に `calendarList list` で確認して置き換える。

```bash
gws calendar events list --params '{"calendarId":"family10527717505002077024@group.calendar.google.com","timeMin":"2026-05-04T00:00:00+09:00","timeMax":"2026-05-10T23:59:59+09:00","singleEvents":true,"orderBy":"startTime"}'
```

## 文字列検索

タイトルや説明に含まれる語で絞る。

```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2026-05-01T00:00:00+09:00","timeMax":"2026-05-31T23:59:59+09:00","singleEvents":true,"orderBy":"startTime","q":"面接"}'
```

## イベント詳細取得

一覧結果の `id` を使って詳細を確認する。

```bash
gws calendar events get --params '{"calendarId":"primary","eventId":"2cq05ee9r17mhigv776s78rq1s"}'
```

## 注意

- 時刻付き予定の期間指定は `timeMin` / `timeMax` を RFC3339 で渡す
- 一覧確認では `singleEvents: true` と `orderBy: "startTime"` を基本にする
- カレンダー未指定なら `primary` と `Family` の両方を対象にする
- `Family` の calendar ID は固定値として決め打ちせず、毎回カレンダー一覧で確認する
- 変更系操作はこの skill の対象外
