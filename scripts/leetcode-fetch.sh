#!/usr/bin/env bash
# LeetCode GraphQL API から問題データを取得するスクリプト
# 使用方法: leetcode-fetch <title-slug>
# 例: leetcode-fetch longest-common-prefix
# 出力: 問題データの JSON（questionFrontendId, title, difficulty, content）

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: leetcode-fetch <title-slug>" >&2
  echo "Example: leetcode-fetch two-sum" >&2
  exit 1
fi

SLUG="$1"

# LeetCode の公開 GraphQL エンドポイントに問題データを問い合わせる
curl -s -X POST https://leetcode.com/graphql \
  -H 'Content-Type: application/json' \
  -d "$(cat <<EOF
{
  "query": "query questionData(\$titleSlug: String!) { question(titleSlug: \$titleSlug) { questionFrontendId title titleSlug difficulty content } }",
  "variables": {"titleSlug": "$SLUG"}
}
EOF
)"
