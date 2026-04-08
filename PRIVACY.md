# Privacy Policy — hdcd-telegram

**Last updated:** 2026-04-08

## What hdcd-telegram does

hdcd-telegram is a local MCP server that bridges Telegram messages to Claude Code sessions. It runs entirely on your machine as a subprocess of Claude Code.

## Data collection

**hdcd-telegram collects no data.** Specifically:

- No analytics or telemetry
- No usage tracking
- No data sent to HyperDev or any third party
- No logs sent externally
- No cookies or browser storage

## Data flow

All data stays between three endpoints:

1. **Telegram Bot API** (`api.telegram.org`) — hdcd-telegram polls for messages and sends replies via HTTPS
2. **Claude Code** — messages are forwarded over local stdio (JSON-RPC), never over the network
3. **Local filesystem** — bot token (`~/.claude/channels/telegram/.env`) and access control (`access.json`) are stored locally

No other network connections are made.

## Voice transcription

If voice transcription is enabled, audio files are processed locally using OpenAI Whisper running on your machine. No audio data is sent to any external service.

## Third-party services

The only external service contacted is the Telegram Bot API (`api.telegram.org`), which is required for bot functionality. Telegram's own privacy policy applies to messages sent through their platform.

## Contact

For privacy questions: maciek@gohyperdev.com

HyperDev P.S.A.
