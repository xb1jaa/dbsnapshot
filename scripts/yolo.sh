#!/bin/bash
# 🤠 YOLO — Merge a PR without code review
set -e
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'; BOLD='\033[1m'

echo -e "\n${CYAN}${BOLD}🤠 YOLO Achievement Unlocker${NC}\n"

unset GITHUB_TOKEN
if ! gh auth status &>/dev/null; then echo "❌ Run: gh auth login"; exit 1; fi
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
[ -z "$REPO" ] && { echo "❌ Not inside a GitHub repo."; exit 1; }

BRANCH="yolo/unlock-$(date +%s)"
DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')

echo -e "📁 Repo: ${GREEN}$REPO${NC}"
echo -e "${GREEN}[1/5]${NC} Creating branch: $BRANCH"
git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"
git checkout -b "$BRANCH"

echo -e "${GREEN}[2/5]${NC} Adding file..."
mkdir -p achievements
cat > achievements/yolo-$(date +%s).md << EOF
# 🤠 YOLO Achievement
Merged without review on $(date).
EOF
git add achievements/
git commit -m "🤠 yolo: unlock achievement — merged without review [skip ci]"

echo -e "${GREEN}[3/5]${NC} Pushing..."
git push origin "$BRANCH"

echo -e "${GREEN}[4/5]${NC} Creating PR..."
PR_URL=$(gh pr create --title "🤠 YOLO Achievement Unlock" \
  --body "Merging without review to unlock YOLO badge. 🤠" \
  --head "$BRANCH" --base "$DEFAULT_BRANCH")
PR_NUM=$(echo "$PR_URL" | grep -oE '[0-9]+$')

echo -e "${GREEN}[5/5]${NC} Merging without review..."
sleep 2
gh pr merge "$PR_NUM" --merge --delete-branch
git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════╗"
echo -e "║  🤠 YOLO — UNLOCKED!                  ║"
echo -e "║  PR #${PR_NUM} merged without review!       ║"
echo -e "╚══════════════════════════════════════╝${NC}\n"
