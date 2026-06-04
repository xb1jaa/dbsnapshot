#!/bin/bash
# 📢 PUBLICIST — Create a GitHub Release
set -e
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'; BOLD='\033[1m'

VERSION="${1:-v1.0.0}"
echo -e "\n${CYAN}${BOLD}📢 PUBLICIST Achievement Unlocker${NC}\n"

unset GITHUB_TOKEN
if ! gh auth status &>/dev/null; then echo "❌ Run: gh auth login"; exit 1; fi
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
[ -z "$REPO" ] && { echo "❌ Not inside a GitHub repo."; exit 1; }

IS_PRIVATE=$(gh repo view --json isPrivate -q '.isPrivate' 2>/dev/null || echo "true")
if [ "$IS_PRIVATE" = "true" ]; then
  echo -e "${YELLOW}⚠️  Repo is PRIVATE. Publicist requires a PUBLIC repo.${NC}"
  echo -e "   Settings → Danger Zone → Make public\n"
  read -p "Continue anyway? (y/N): " C
  [ "$C" != "y" ] && [ "$C" != "Y" ] && exit 0
fi

echo -e "📁 Repo: ${GREEN}$REPO${NC} | Version: ${GREEN}$VERSION${NC}\n"

echo -e "${GREEN}[1/3]${NC} Creating tag..."
git tag -a "$VERSION" -m "Release $VERSION" 2>/dev/null || echo "  Tag exists, continuing..."
git push origin "$VERSION" 2>/dev/null || echo "  Tag already pushed"

echo -e "${GREEN}[2/3]${NC} Creating release..."
gh release create "$VERSION" \
  --title "🚀 $VERSION" \
  --notes "## $VERSION

Initial release. See README for full details.

### Quick Start
\`\`\`bash
bash scripts/setup.sh
bash scripts/unlock-all.sh
\`\`\`" \
  --latest

echo -e "${GREEN}[3/3]${NC} Verifying..."
gh release view "$VERSION" --json tagName -q '"✅ Release: \(.tagName)"'

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════════╗"
echo -e "║  📢 PUBLICIST — UNLOCKED!                ║"
echo -e "║  ⚠️  Repo must be PUBLIC for badge        ║"
echo -e "╚══════════════════════════════════════════╝${NC}\n"
echo -e "🔗 https://github.com/${REPO}/releases/tag/${VERSION}\n"
