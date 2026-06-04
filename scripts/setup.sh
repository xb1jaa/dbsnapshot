#!/bin/bash
# ============================================================
# 🛠️  Setup Script — dbsnapshot
# ============================================================
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'

echo -e "\n${CYAN}${BOLD}🛠️  dbsnapshot — Environment Setup${NC}\n"

echo -e "${GREEN}[1/4]${NC} Checking Git..."
command -v git &>/dev/null && echo -e "  ✅ $(git --version)" || { sudo apt-get install -y git; }

echo -e "${GREEN}[2/4]${NC} Checking GitHub CLI..."
if ! command -v gh &>/dev/null; then
  echo "  Installing gh CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update && sudo apt install gh -y
else
  echo -e "  ✅ $(gh --version | head -1)"
fi

echo -e "${GREEN}[3/4]${NC} Checking Node.js..."
command -v node &>/dev/null && echo -e "  ✅ Node $(node --version)" || echo -e "  ${YELLOW}⚠️  Node not found — install Node 18+${NC}"

echo -e "${GREEN}[4/4]${NC} Setting script permissions..."
chmod +x scripts/*.sh
echo -e "  ✅ All scripts executable"

echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════════╗"
echo -e "║  ✅ Setup complete!                       ║"
echo -e "║                                          ║"
echo -e "║  Next:  unset GITHUB_TOKEN               ║"
echo -e "║         gh auth login                    ║"
echo -e "║         bash scripts/unlock-all.sh       ║"
echo -e "╚══════════════════════════════════════════╝${NC}\n"
