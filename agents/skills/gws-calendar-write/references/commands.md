# gws Calendar コマンド例

## カレンダー一覧

```bash
gws calendar calendarList list --params '{"minAccessRole":"reader"}'
```

## 予定検索

`q` でタイトルや説明の文字列検索、`timeMin` / `timeMax` で期間絞り込みをする。

```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2026-05-01T00:00:00+09:00","timeMax":"2026-05-31T23:59:59+09:00","singleEvents":true,"orderBy":"startTime","q":"PayPay"}'
```

## 予定詳細取得

```bash
gws calendar events get --params '{"calendarId":"primary","eventId":"2cq05ee9r17mhigv776s78rq1s"}'
```

## 予定作成

```bash
gws calendar events insert \
  --params '{"calendarId":"family10527717505002077024@group.calendar.google.com"}' \
  --json '{"summary":"PayPayカード面接","start":{"dateTime":"2026-05-12T11:00:00+09:00","timeZone":"Asia/Tokyo"},"end":{"dateTime":"2026-05-12T12:00:00+09:00","timeZone":"Asia/Tokyo"},"location":"https://meet.google.com/fyt-tvou-nni","description":"候補者: 幸寛 荒川 様"}'
```

終日予定:

```bash
gws calendar events insert \
  --params '{"calendarId":"primary"}' \
  --json '{"summary":"出張日","start":{"date":"2026-05-22"},"end":{"date":"2026-05-23"}}'
```

## 予定更新

開始・終了時刻だけ変える:

```bash
gws calendar events patch \
  --params '{"calendarId":"primary","eventId":"2cq05ee9r17mhigv776s78rq1s"}' \
  --json '{"start":{"dateTime":"2026-05-12T12:00:00+09:00","timeZone":"Asia/Tokyo"},"end":{"dateTime":"2026-05-12T13:00:00+09:00","timeZone":"Asia/Tokyo"}}'
```

場所と説明を足す:

```bash
gws calendar events patch \
  --params '{"calendarId":"primary","eventId":"2cq05ee9r17mhigv776s78rq1s"}' \
  --json '{"location":"東京駅","description":"集合は10分前"}'
```

## 注意

- 終日は `start.date` / `end.date` を使う。`end.date` は翌日で閉じる
- 時刻あり予定は `dateTime` と `timeZone` をセットで渡す
- 大きな置換が不要なら `update` ではなく `patch` を使う
