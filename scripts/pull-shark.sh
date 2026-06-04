#!/bin/bash
# 🦈 PULL SHARK — Batch PR creator
set -e
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'; BOLD='\033[1m'

COUNT=${1:-2}
echo -e "\n${CYAN}${BOLD}🦈 PULL SHARK — Creating $COUNT PR(s)${NC}\n"

unset GITHUB_TOKEN
if ! gh auth status &>/dev/null; then echo "❌ Run: gh auth login"; exit 1; fi
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
[ -z "$REPO" ] && { echo "❌ Not inside a GitHub repo."; exit 1; }

DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
echo -e "📁 Repo: ${GREEN}$REPO${NC} | PRs: ${GREEN}$COUNT${NC}\n"
echo -e "🏅 Tiers: 🥉 Bronze=2  🥈 Silver=16  🥇 Gold=128  💎 Diamond=1024\n"

for i in $(seq 1 "$COUNT"); do
  TS=$(date +%s)
  BRANCH="pull-shark/pr-${i}-${TS}"
  git checkout "$DEFAULT_BRANCH" 2>/dev/null && git pull origin "$DEFAULT_BRANCH" 2>/dev/null
  git checkout -b "$BRANCH"

  mkdir -p achievements/pull-shark
  cat > "achievements/pull-shark/contribution-${i}-${TS}.md" << EOF
# 🦈 Pull Shark Contribution #${i}
Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

Tier progress: 🥉 2 → 🥈 16 → 🥇 128 → 💎 1024
EOF
  git add .
  git commit -m "🦈 pull-shark: contribution #${i} [${TS}] [skip ci]"
  git push origin "$BRANCH"

  PR_URL=$(gh pr create \
    --title "🦈 Pull Shark #${i} — $(date '+%H:%M:%S')" \
    --body "Pull Shark achievement contribution #${i}/${COUNT}" \
    --head "$BRANCH" --base "$DEFAULT_BRANCH")
  PR_NUM=$(echo "$PR_URL" | grep -oE '[0-9]+$')
  sleep 1
  gh pr merge "$PR_NUM" --merge --delete-branch
  echo -e "  ✅ [${i}/${COUNT}] PR #${PR_NUM} merged"
  [ "$i" -lt "$COUNT" ] && sleep 2
done

git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════════╗"
echo -e "║  🦈 PULL SHARK — $COUNT PR(s) Merged!          ║"
echo -e "║  For Silver: bash scripts/pull-shark.sh 16 ║"
echo -e "╚══════════════════════════════════════════╝${NC}\n"
