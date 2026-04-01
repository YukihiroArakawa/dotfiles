---
name: leetcode
description: LeetCode の問題 URL から問題ファイル（日本語）を作成する
---

# LeetCode 問題取得スキル

LeetCode の問題 URL を受け取り、問題内容を日本語に翻訳した Markdown ファイルを作成する。

## 入力

- **必須**: LeetCode の問題 URL（例: `https://leetcode.com/problems/two-sum/description/`）
- **任意**: 出力先ディレクトリ（未指定の場合はカレントディレクトリ）

## 手順

### 1. URL から問題スラッグを抽出する

URL パターン: `https://leetcode.com/problems/{slug}/...`

例: `https://leetcode.com/problems/longest-common-prefix/description/` → スラッグは `longest-common-prefix`

### 2. `leetcode-fetch` コマンドで問題データを取得する

`leetcode-fetch` は LeetCode GraphQL API から問題データを取得するスクリプト（Nix で管理、~/.local/bin に配置済み）。

```bash
leetcode-fetch <slug>
```

レスポンスは JSON 形式で、以下のフィールドを含む:

- `data.question.questionFrontendId`: LeetCode 上で表示される問題番号（例: "14"）
- `data.question.title`: 問題タイトル（例: "Longest Common Prefix"）
- `data.question.titleSlug`: URL スラッグ（例: "longest-common-prefix"）
- `data.question.difficulty`: 難易度（"Easy" / "Medium" / "Hard"）
- `data.question.content`: 問題文（HTML 形式）

### 3. ディレクトリとファイルを作成する

以下の構造で作成する:

```
{出力先ディレクトリ}/{問題番号}-{スラッグ}/{yyyyMMdd}/
├── problem.md              # 原文の問題文（英語）
├── problem-ja.md           # 日本語訳の問題文
├── FirstSolution/
│   └── Solution.java       # 解答用のクラスファイル（雛形）
└── AISolution/
    └── Solution.java       # Claude による模範解答（解説コメント付き）
```

- `{問題番号}`: `questionFrontendId` を使用（例: `14`）
- `{スラッグ}`: URL のスラッグをそのまま使用（例: `longest-common-prefix`）
- `{yyyyMMdd}`: 本日の日付（例: `20260331`）

例: `./14-longest-common-prefix/20260331/`

### 4. 各ファイルの内容

#### problem.md（原文）

API から取得した HTML の問題文を Markdown に変換し、そのまま英語で記載する:

```markdown
# {問題番号}. {title}

Difficulty: {Easy/Medium/Hard}

## Problem

{原文の問題文をそのまま記載}

## Examples

{各例を原文のまま記載。Input・Output・Explanation を含む}

## Constraints

{制約条件を原文のまま記載}
```

#### problem-ja.md（日本語訳）

problem.md の内容を日本語に翻訳して記載する:

```markdown
# {問題番号}. {日本語タイトル}

難易度: {Easy/Medium/Hard}

## 問題

{問題文を日本語に翻訳して記載}

## 例

{各例を日本語で記載。入力・出力・説明を含む}

## 制約

{制約条件を日本語で記載}
```

#### FirstSolution/Solution.java（解答雛形）

LeetCode の問題に対応する Java クラスの雛形を作成する。
API レスポンスの問題文からメソッドシグネチャを読み取り、それに合わせた雛形を生成する。

```java
class Solution {
    // {メソッドシグネチャ（問題文から読み取る）}
}
```

#### AISolution/Solution.java（模範解答）

AI が作成する模範解答。アルゴリズムの選択理由、計算量、処理の流れをコードコメントで解説する。
変数名は意味が伝わる名前をつけること。ループ変数（`i`, `j`, `k`）を除き、1文字変数の使用は禁止。

```java
// 問題: {問題番号}. {タイトル}
// アプローチ: {使用するアルゴリズム・データ構造の概要}
// 時間計算量: O(...)
// 空間計算量: O(...)
class Solution {
    // {解説コメント付きの完全な実装}
}
```

### ルール

- 問題文の日本語訳は正確に翻訳する。意訳は最小限にとどめる
- コード例、変数名、データ構造名（例: `nums`, `ListNode`）は原文のまま残す
- 数式や数値条件もそのまま保持する
- HTML タグは Markdown に変換する（`<code>` → バッククォート、`<sup>` → `^` 等）
- Solution.java のメソッドシグネチャは問題文中のコード例から正確に読み取る
