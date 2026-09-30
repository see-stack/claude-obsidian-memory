# Claude Obsidian Memory

A persistent context and agent workflow system for Claude Code using Obsidian.

Claude Code sessions normally start without the context from your previous work. This setup gives Claude a persistent file-based memory system so it can recover previous sessions, read journal entries, track unfinished tasks, and continue where you left off.

## Demo

🎥 Full walkthrough:
https://youtu.be/t_sOfWli9aU

## What this includes

- Persistent Claude Code context
- Auto-memory stored inside Obsidian
- Daily journal system
- Commands
- Skills
- Scripts
- Agent configuration
- Session recovery
- Obsidian-based knowledge structure

## How it works

Claude Code
↓
Commands / Skills
↓
Journal + Auto Memory
↓
Obsidian Vault
↓
Persistent Context

Your context stays in normal Markdown files that you control.

## Repository structure

```text
AI-Knowledge-Base/
├── Agents/
│   ├── Commands/
│   ├── Skills/
│   ├── Scripts/
│   └── Config/
├── Journal/
├── Templates/
└── ...
