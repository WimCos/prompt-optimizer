#!/usr/bin/env bash
# Build the uploadable skill zip for claude.ai / Claude Desktop into dist/.
# Bash script - run as ./tools/zip-skill.sh (works fine from a fish shell).
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p dist
rm -f dist/prompt-optimizer-skill.zip

(
  cd plugins/prompt-optimizer/skills
  zip -r ../../../dist/prompt-optimizer-skill.zip prompt-optimizer \
    -x "*.DS_Store"
)

echo "Built dist/prompt-optimizer-skill.zip"
echo "Upload via claude.ai > Settings > Capabilities > Skills."
