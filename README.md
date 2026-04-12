# hdcd-telegram plugin

Claude Code plugin for [hdcd-telegram](https://github.com/gohyperdev/hdcd-telegram) — a Rust-based Telegram channel server.

3.5 MB binary. ~5 MB RAM. <50 ms startup. Full feature parity with the official Telegram plugin. Zero migration needed.

## Install

```
/plugin install hdcd-telegram@gohyperdev
```

The plugin automatically downloads the correct binary for your platform on first use.

## Setup

1. Create a bot via [@BotFather](https://t.me/BotFather) on Telegram
2. Configure the token:
   ```
   /telegram:configure <your-bot-token>
   ```
3. Restart Claude Code:
   ```bash
   claude --dangerously-load-development-channels plugin:hdcd-telegram@hyperdev-plugins
   ```
4. DM your bot — it replies with a pairing code
5. Pair:
   ```
   /telegram:access pair <code>
   ```

## Running alongside the official Telegram plugin

hdcd-telegram supports `HDCD_TELEGRAM_BOT_TOKEN` as an alternative env var (v0.1.2+).
This lets you run both plugins with separate bots — no token conflict:

```bash
# ~/.claude/channels/telegram/.env
HDCD_TELEGRAM_BOT_TOKEN=<your-hdcd-bot-token>
TELEGRAM_BOT_TOKEN=<official-plugin-bot-token>
```

Priority: `HDCD_TELEGRAM_BOT_TOKEN` > `TELEGRAM_BOT_TOKEN` (env and .env).
If only `TELEGRAM_BOT_TOKEN` is set, it works as before — fully backward compatible.

## Skills

| Skill | Description |
|---|---|
| `/telegram:configure` | Save bot token, check status, setup walkthrough |
| `/telegram:access` | Manage pairings, allowlists, group policies |

## Features

- All 8 Telegram message types (text, photo, document, voice, audio, video, video note, sticker)
- 4 MCP tools: reply, react, edit_message, download_attachment
- Access control with pairing flow and group policies
- Voice transcription via Whisper (optional, local)
- Permission relay for remote tool-use approval
- Clean shutdown on stdin EOF

## Requirements

- macOS (Intel or Apple Silicon), Linux (x86_64 or ARM64), or Windows
- curl (for binary download)
- Claude Code 2.1.90+

## License

Apache-2.0
