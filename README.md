# Claude Obsidian Memory

[![Use This Template](https://img.shields.io/badge/Template-Use_This_Template-2ea44f?style=for-the-badge&logo=github)](https://github.com/see-stack/claude-obsidian-memory/generate)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![YouTube Walkthrough](https://img.shields.io/badge/YouTube-Watch%20Walkthrough-red?style=for-the-badge&logo=youtube)](https://youtu.be/t_sOfWli9aU)
[![Website](https://img.shields.io/badge/Website-seestack.dev-00f2fe?style=for-the-badge)](https://seestack.dev)
[![Organization](https://img.shields.io/badge/Organization-@seestacks-1f2937?style=for-the-badge&logo=github)](https://github.com/seestacks)

A persistent context, agent workflow, and session-recovery system for **Claude Code** using **Obsidian**.

---

## ⚡ The Problem

Claude Code sessions start completely blind:
* Every new terminal session begins without any context from your previous conversation.
* Important architectural decisions, completed work, and pending blockers are trapped in conversation history or scattered across hidden dotfiles.
* You end up re-explaining the same project and setup every single time you open your terminal.

---

## 💡 The Solution

**Claude Obsidian Memory** provides a local-first, file-based memory architecture:
* Your AI agent’s memory, custom commands, and skills live directly inside your **Obsidian vault as plain Markdown files**.
* Symbolic links bridge your Obsidian vault to Claude Code's config directory (`~/.claude/`), so Claude reads and updates them natively.
* When you start a session days or weeks later, Claude scans your daily journal hierarchy, recovers where you left off, and continues working with zero amnesia.

```
       ┌────────────────────────────────────────────────────────┐
       │                 TERMINAL / CLAUDE CODE                 │
       └───────────────────────────┬────────────────────────────┘
                                   │  Reads & Writes via Symlinks
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                     OBSIDIAN VAULT                     │
       │                                                        │
       │   ├── Agents/                                          │
       │   │   ├── Commands/   (Custom slash commands)          │
       │   │   ├── Skills/     (Reusable agent recipes)         │
       │   │   ├── Scripts/    (Deterministic bash automations) │
       │   │   └── Config/     (Auto-memory & settings.json)    │
       │   ├── Journal/        (Year / Month / Day hierarchy)   │
       │   └── Templates/      (Daily note markdown scaffolds)  │
       └────────────────────────────────────────────────────────┘
```

---

## 🎥 Video Walkthrough

Watch the complete, end-to-end setup and the 23-day memory test:  
▶️ **[The Permanent Context & Memory Fix for Claude Code](https://youtu.be/t_sOfWli9aU)**

---

## 📦 What's Included

* **Persistent Claude Code Context**: Long-term memory stored outside the chat window.
* **Auto-Memory Redirection**: Claude Code's auto-memory routed into Obsidian where you can view, edit, and link it.
* **Daily Journal System**: Automated `Year / Month / Day` note generation with standardized markdown templates.
* **Custom Agent Commands**: Slash commands (e.g. `/daily-journal`, `/get-context`) ready to trigger from your CLI.
* **Reusable Agent Skills**: Structured workflows defined in markdown recipes (`SKILL.md`).
* **Deterministic Scripts**: Bash scripts (`daily-journal.sh`) that build note hierarchies safely without AI hallucinations.
* **Session Recovery**: Prompt protocols that let Claude reconstruct previous sessions and find unfinished tasks.

---

## 🚀 Quick Start & Installation

### Prerequisites
* [Claude Code CLI](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) installed and working in your terminal.
* [Obsidian](https://obsidian.md/) installed locally.

---

### Step 1: Add to Your Vault
Clone this repository or copy the `AI-Knowledge-Base/` folder directly into your Obsidian vault directory:

```bash
git clone https://github.com/see-stack/claude-obsidian-memory.git
```

Move or copy the contents into your vault root, or open `AI-Knowledge-Base` as a standalone vault in Obsidian.

---

### Step 2: Configure Claude Code Auto-Memory
1. Open Claude Code's global configuration file:
   ```bash
   nano ~/.claude/settings.json
   ```
2. Set the `autoMemoryDirectory` to point to the `Agents/Config/auto-memory` folder in your Obsidian vault:
   ```json
   {
     "autoMemoryDirectory": "/absolute/path/to/your/ObsidianVault/Agents/Config/auto-memory"
   }
   ```
3. Save the file. Claude Code will now store and read its memory directly from your Obsidian vault.

---

### Step 3: Symlink Commands and Skills
To make your custom vault commands and skills accessible to Claude Code from anywhere on your machine, create symbolic links from your vault to `~/.claude/`:

```bash
# Symlink custom slash commands
ln -s "/absolute/path/to/your/ObsidianVault/Agents/Commands" ~/.claude/commands

# Symlink agent skills
ln -s "/absolute/path/to/your/ObsidianVault/Agents/Skills" ~/.claude/skills
```

Now, any custom command or skill you edit inside Obsidian is immediately recognized by Claude Code in the terminal.

---

### Step 4: Configure Obsidian Daily Notes
1. Open Obsidian **Settings** -> **Core Plugins** -> Enable **Daily Notes** and **Templates**.
2. In **Templates** settings:
   * Set **Template folder location** to `Templates`.
3. In **Daily Notes** settings:
   * Set **Date format** to `YYYY/MM/DD`.
   * Set **New file location** to `Journal`.
   * Set **Template file location** to `Templates/Daily-Journal-Template`.

Now, clicking the Daily Note button automatically creates the `Year/Month/Day` folder hierarchy with your standardized template sections.

---

### Step 5: Test the Setup
Open your terminal and launch Claude Code:

```bash
claude
```

1. **Verify memory**: Run `/memory` inside Claude. You will see it pointing directly to your Obsidian vault.
2. **Run the journal workflow**:
   ```text
   /daily-journal Log this session.
   ```
   Claude will execute `daily-journal.sh`, build today's note hierarchy, populate your focus, dev logs, and completed tasks, and link it into your Obsidian knowledge graph.
3. **Test recovery in a fresh session**:
   Exit Claude, reopen a new terminal session, and ask:
   ```text
   What did we work on in our last recorded session, and what tasks are still pending?
   ```
   Claude will scan your journal files, reconstruct your last session, and report your exact progress.

---

## 📁 Repository Structure

```text
AI-Knowledge-Base/
├── Agents/
│   ├── Commands/             # Custom Claude Code slash commands (.md)
│   ├── Skills/               # Reusable agent workflows (SKILL.md)
│   ├── Scripts/              # Bash automations (daily-journal.sh)
│   └── Config/
│       ├── auto-memory/      # Claude Code persistent memory directory
│       └── settings.json     # Symlinked Claude settings
├── Journal/
│   └── 2026/                 # Auto-generated Year / Month / Day daily notes
├── Templates/
│   └── Daily-Journal-Template.md # Scaffolding for daily focus, logs & tasks
└── CLAUDE.md                 # Project-level agent rules and guidelines
```

---

## 🔒 Security & Privacy

* **Zero Cloud Lock-in**: All context, journals, and memories are stored locally on your machine in plain Markdown files.
* **Secret Isolation**: Never commit API keys or tokens into your Obsidian vault or Git repository. Keep credentials in a dedicated, git-ignored directory outside your notes.

---

## 🌐 Community & Ecosystem

* **Website**: [seestack.dev](https://seestack.dev) — Real AI workflows, tools, and developer setups.
* **YouTube**: [@SeeStack](https://youtube.com/@SeeStack) — Step-by-step video tutorials and system breakdowns.
* **GitHub Organization**: [@seestacks](https://github.com/seestacks)
* **X**: [@seestackx](https://x.com/seestackx) — Rapid tooling drops and architecture notes.
* **Bluesky**: [@seestack.bsky.social](https://bsky.app/profile/seestack.bsky.social)
* **Instagram**: [@see.stack](https://instagram.com/see.stack) — Fast tips and agent demos.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
