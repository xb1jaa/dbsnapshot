#!/bin/bash
# 🏆 MASTER ACHIEVEMENT UNLOCKER
set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; PURPLE='\033[0;35m'; NC='\033[0m'; BOLD='\033[1m'

clear
echo -e "\n${CYAN}${BOLD}  🏆 GitHub Achievement Master Unlocker${NC}\n"

# Auth
unset GITHUB_TOKEN
if ! gh auth status &>/dev/null; then
  echo -e "${RED}❌ Not logged in. Run: gh auth login${NC}"; exit 1
fi
GH_USER=$(gh api user -q .login)
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
[ -z "$REPO" ] && { echo -e "${RED}❌ Not inside a GitHub repo.${NC}"; exit 1; }

echo -e "  ✅ Logged in as ${GREEN}@${GH_USER}${NC}"
echo -e "  📁 Repo: ${GREEN}$REPO${NC}\n"

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}1)${NC} 🚀 Quick Run  — ⚡ Quickdraw + 🤠 YOLO + 📢 Publicist"
echo -e "  ${GREEN}2)${NC} 🦈 Pull Shark  — Create & merge N PRs"
echo -e "  ${GREEN}3)${NC} 🤝 Pair Extraordinaire — Co-author a PR"
echo -e "  ${GREEN}4)${NC} 📢 Publicist    — Create a GitHub Release"
echo -e "  ${GREEN}5)${NC} 🔥 Full Blast   — Everything at once"
echo -e "  ${GREEN}6)${NC} 📊 Status Check — Current progress"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
read -p "  Choice [1-6]: " CHOICE
echo ""

case "$CHOICE" in
  1)
    bash scripts/quickdraw.sh
    bash scripts/yolo.sh
    bash scripts/publicist.sh
    ;;
  2)
    read -p "  How many PRs? (default 2): " N; N=${N:-2}
    bash scripts/pull-shark.sh "$N"
    ;;
  3)
    read -p "  Partner name: " PN
    read -p "  Partner GitHub email: " PE
    bash scripts/pair-extraordinaire.sh "$PN" "$PE"
    ;;
  4)
    bash scripts/publicist.sh
    ;;
  5)
    bash scripts/quickdraw.sh
    bash scripts/yolo.sh
    bash scripts/publicist.sh
    read -p "  PRs for Pull Shark (default 2): " N; N=${N:-2}
    bash scripts/pull-shark.sh "$N"
    ;;
  6)
    MERGED=$(gh pr list --state merged --author "@me" --json number -q 'length' 2>/dev/null || echo 0)
    RELEASES=$(gh release list --json tagName -q 'length' 2>/dev/null || echo 0)
    echo -e "  🦈 Merged PRs: ${GREEN}${MERGED}${NC}"
    echo -e "  📢 Releases:   ${GREEN}${RELEASES}${NC}"
    echo -e "  🔗 https://github.com/${GH_USER}"
    ;;
  *)
    echo -e "${RED}Invalid choice.${NC}"; exit 1 ;;
esac

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════════════════════╗"
echo -e "║  🏆 Done! Badges appear within 2–24 hours.           ║"
echo -e "║  Check: https://github.com/${GH_USER}              ║"
echo -e "║  ⭐ Star this repo to help others!                   ║"
echo -e "╚══════════════════════════════════════════════════════╝${NC}\n"
