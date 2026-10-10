#!/usr/bin/env bash
# ==============================================================================
# Claude Obsidian Memory — Automated Environment Setup
# https://github.com/see-stack/claude-obsidian-memory
# ==============================================================================
set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}=== Claude Obsidian Memory Setup ===${RESET}\n"

# 1. Resolve Vault Path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VAULT_DIR="${1:-$REPO_DIR/AI-Knowledge-Base}"

if [ ! -d "$VAULT_DIR" ]; then
  echo -e "${YELLOW}Vault directory not found at:${RESET} $VAULT_DIR"
  echo "Usage: ./scripts/setup.sh [path/to/ObsidianVault]"
  exit 1
fi

echo -e "📂 Vault location: ${BOLD}$VAULT_DIR${RESET}"

# 2. Link Obsidian CLI (macOS)
echo -e "\n${BOLD}[1/4] Checking Obsidian CLI...${RESET}"
OBSIDIAN_APP="/Applications/Obsidian.app/Contents/MacOS/obsidian"
LOCAL_BIN="$HOME/.local/bin"

if command -v obsidian >/dev/null 2>&1; then
  echo -e "${GREEN}✓${RESET} Obsidian CLI is already available at: $(which obsidian)"
elif [ -f "$OBSIDIAN_APP" ]; then
  mkdir -p "$LOCAL_BIN"
  ln -sf "$OBSIDIAN_APP" "$LOCAL_BIN/obsidian"
  echo -e "${GREEN}✓${RESET} Linked Obsidian CLI to $LOCAL_BIN/obsidian"
  if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo -e "${YELLOW}⚠ Note:${RESET} Add $LOCAL_BIN to your PATH by adding this to your ~/.zshrc or ~/.bashrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi
else
  echo -e "${YELLOW}⚠ Obsidian app not found at standard path (/Applications/Obsidian.app).${RESET}"
  echo "  If Obsidian is installed elsewhere, symlink its internal binary to your PATH."
fi

# 3. Create Claude Code config directory and symlinks
echo -e "\n${BOLD}[2/4] Symlinking Commands & Skills into Claude Code...${RESET}"
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

COMMANDS_SRC="$VAULT_DIR/Agents/Commands"
SKILLS_SRC="$VAULT_DIR/Agents/Skills"

if [ -d "$COMMANDS_SRC" ]; then
  ln -sf "$COMMANDS_SRC" "$CLAUDE_DIR/commands"
  echo -e "${GREEN}✓${RESET} Linked commands: $CLAUDE_DIR/commands -> $COMMANDS_SRC"
fi

if [ -d "$SKILLS_SRC" ]; then
  ln -sf "$SKILLS_SRC" "$CLAUDE_DIR/skills"
  echo -e "${GREEN}✓${RESET} Linked skills: $CLAUDE_DIR/skills -> $SKILLS_SRC"
fi

# 4. Configure Claude Code settings.json
echo -e "\n${BOLD}[3/4] Configuring Claude Code permissions & auto-memory...${RESET}"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
AUTO_MEMORY_PATH="$VAULT_DIR/Agents/Config/Auto-memory"

mkdir -p "$AUTO_MEMORY_PATH"

python3 - <<EOF
import json
import os

settings_path = os.path.expanduser("$SETTINGS_FILE")
auto_memory_path = os.path.abspath("$AUTO_MEMORY_PATH")

data = {}
if os.path.exists(settings_path) and os.path.getsize(settings_path) > 0:
    try:
        with open(settings_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Warning: Could not parse existing settings.json ({e}). Creating backup.")
        os.rename(settings_path, settings_path + ".backup")
        data = {}

# Ensure permissions structure
permissions = data.setdefault("permissions", {})
allow_list = permissions.setdefault("allow", [])

# Required permissions for seamless Obsidian operation
required_perms = [
    "Bash(obsidian *)",
    "Bash(ls *)",
    "Bash(find *)",
    "Bash(mkdir *)"
]

for perm in required_perms:
    if perm not in allow_list:
        allow_list.append(perm)

# Set auto-memory directory
data["autoMemoryDirectory"] = auto_memory_path

with open(settings_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2)
    f.write("\n")

print(f"Successfully configured {settings_path}")
EOF

echo -e "${GREEN}✓${RESET} Added 'Bash(obsidian *)' permission to $SETTINGS_FILE"
echo -e "${GREEN}✓${RESET} Set autoMemoryDirectory to $AUTO_MEMORY_PATH"

# 5. Verification
echo -e "\n${BOLD}[4/4] Verifying Setup...${RESET}"
if command -v obsidian >/dev/null 2>&1; then
  echo -e "${GREEN}✓${RESET} Obsidian CLI response: $(obsidian version 2>/dev/null || echo 'Ready')"
else
  echo -e "${YELLOW}Obsidian CLI not found in current PATH. Reopen terminal or export PATH.${RESET}"
fi

echo -e "\n${BOLD}${GREEN}=== Setup Complete! ===${RESET}"
echo -e "You can now launch Claude Code and run:"
echo -e "  ${BOLD}claude${RESET}"
echo -e "  ${BOLD}/daily-journal Log session progress${RESET}\n"
echo -e "${BOLD}${YELLOW}⭐ Support the Project:${RESET}"
echo -e "If this setup saves you time and context, please consider starring the repo on GitHub:"
echo -e "👉 ${CYAN}${BOLD}https://github.com/see-stack/claude-obsidian-memory${RESET}\n"
