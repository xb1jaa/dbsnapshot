#!/bin/bash
# ⚡ QUICKDRAW — Close an issue within 5 minutes of opening
set -e
GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'

echo -e "\n${CYAN}${BOLD}⚡ QUICKDRAW Achievement Unlocker${NC}\n"

unset GITHUB_TOKEN
if ! gh auth status &>/dev/null; then echo "❌ Run: gh auth login"; exit 1; fi
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
[ -z "$REPO" ] && { echo "❌ Not inside a GitHub repo."; exit 1; }

echo -e "📁 Repo: ${GREEN}$REPO${NC}\n"
echo -e "${GREEN}[1/3]${NC} Creating issue..."
ISSUE_URL=$(gh issue create --title "⚡ Quickdraw Test - $(date +%s)" --body "Auto-created for Quickdraw achievement. Closing immediately.")
ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -oE '[0-9]+$')
echo -e "  ✅ Issue #${ISSUE_NUMBER} created"

echo -e "${GREEN}[2/3]${NC} Waiting 2 seconds..."
sleep 2

echo -e "${GREEN}[3/3]${NC} Closing issue..."
gh issue close "$ISSUE_NUMBER" --comment "⚡ Quickdraw! Closed within 5 minutes."

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════╗"
echo -e "║  ⚡ QUICKDRAW — UNLOCKED!              ║"
echo -e "║  Badge appears within 24 hours        ║"
echo -e "╚══════════════════════════════════════╝${NC}\n"
