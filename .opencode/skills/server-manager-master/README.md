# Server Manager

[中文版 →](README_zh.md)

Start, track, and stop local dev servers in the background — without blocking your AI conversation.

## The Problem

Running `npm run dev` in an AI terminal (like OpenCode) blocks the session entirely. This skill solves it with fully non-blocking background server management.

## Installation

Download the entire `server-manager/` folder into your AI coding tool's skills directory:

- **OpenCode**: `~/.config/opencode/skills/server-manager/`
- **Claude Code**: `~/.claude/skills/server-manager/`
- **Project-level**: `.opencode/skills/` or `.claude/skills/` in your project root

## Supported Stacks

Any dev server that listens on a port: Next.js, Vite, HyperFrames, Remotion, Streamlit, Flask, Django, Go, Rust, and more.

## Commands

| Command | Description |
|---------|-------------|
| `start-server` | Start server, non-blocking |
| `stop-server` | Stop one server |
| `stop-all` | Stop all servers |
| `list-servers` | List active servers |
| `health-server` | HTTP health check |
| `tail-server` | Tail server log |
| `grep-server` | Search log keywords |
