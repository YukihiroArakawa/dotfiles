---
name: commit
description: Conventional Commit 形式で git commit を作成する
---

# Git Commit スキル

変更内容を分析し、Conventional Commit 形式でコミットメッセージを作成してコミットする。

## コミットメッセージのフォーマット

```
<type>: <簡潔な説明>
```

### type は以下のいずれかを使用する

- `feat`: 新機能の追加
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `perf`: パフォーマンス改善

### ルール

- type は必ず上記4種のいずれかを選択すること
- 説明は簡潔に、変更の意図（why）を中心に記述すること
- 日本語・英語どちらでも可（リポジトリの既存コミット履歴に合わせる）
