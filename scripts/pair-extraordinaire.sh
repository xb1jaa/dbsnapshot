#!/bin/bash
# 🤝 PAIR EXTRAORDINAIRE — Co-authored PR
set -e
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'; BOLD='\033[1m'

COAUTHOR_NAME="${1:-Pair Partner}"
COAUTHOR_EMAIL="${2:-partner@example.com}"

echo -e "\n${CYAN}${BOLD}🤝 PAIR EXTRAORDINAIRE Unlocker${NC}"
echo -e "${YELLOW}  Co-author: ${COAUTHOR_NAME} <${COAUTHOR_EMAIL}>${NC}"
echo -e "${YELLOW}  ⚠️  Email must match their GitHub account!${NC}\n"

unset GITHUB_TOKEN
if ! gh auth status &>/dev/null; then echo "❌ Run: gh auth login"; exit 1; fi
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
[ -z "$REPO" ] && { echo "❌ Not inside a GitHub repo."; exit 1; }

DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
BRANCH="pair/extraordinaire-$(date +%s)"

git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"
git checkout -b "$BRANCH"

mkdir -p achievements/pair-extraordinaire
cat > achievements/pair-extraordinaire/collab-$(date +%s).md << EOF
# 🤝 Pair Extraordinaire

**Authors:** $(git config user.name) & ${COAUTHOR_NAME}
**Date:** $(date -u +"%Y-%m-%d")

Tiers: 🥉 2 → 🥈 16 → 🥇 128 → 💎 1024 co-authored PRs
EOF

git add .
git commit -m "🤝 pair: co-authored contribution

Co-authored-by: ${COAUTHOR_NAME} <${COAUTHOR_EMAIL}>"

git push origin "$BRANCH"

PR_URL=$(gh pr create \
  --title "🤝 Pair Extraordinaire: $(git config user.name) & ${COAUTHOR_NAME}" \
  --body "Co-authored PR for Pair Extraordinaire badge.

Co-authored-by: ${COAUTHOR_NAME} <${COAUTHOR_EMAIL}>" \
  --head "$BRANCH" --base "$DEFAULT_BRANCH")
PR_NUM=$(echo "$PR_URL" | grep -oE '[0-9]+$')
sleep 2
gh pr merge "$PR_NUM" --merge --delete-branch
git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗"
echo -e "║  🤝 PAIR EXTRAORDINAIRE — UNLOCKED!          ║"
echo -e "║  Both contributors earn the badge!           ║"
echo -e "╚══════════════════════════════════════════════╝${NC}\n"
echo -e "Usage: bash scripts/pair-extraordinaire.sh 'Name' 'email@github.com'\n"
