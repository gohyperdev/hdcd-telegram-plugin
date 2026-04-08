---
name: configure
description: Set up the Telegram channel — save the bot token and verify configuration. Use when the user pastes a Telegram bot token, asks to configure Telegram, asks "how do I set this up", or wants to check channel status.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Bash(ls *)
  - Bash(mkdir *)
  - Bash(chmod *)
---

# /telegram:configure — Telegram Channel Setup

Set up or verify the Telegram channel configuration for hdcd-telegram.

## When the user provides a bot token

1. Validate format: should match `\d+:[\w-]+` (e.g. `123456789:AAHfiqksKZ8...`)
2. Create the state directory:
   ```bash
   mkdir -p ~/.claude/channels/telegram
   ```
3. Write the token:
   ```bash
   echo "TELEGRAM_BOT_TOKEN=<token>" > ~/.claude/channels/telegram/.env
   chmod 600 ~/.claude/channels/telegram/.env
   ```
4. Confirm: "Token saved. Restart Claude Code with `--dangerously-load-development-channels server:telegram` to activate."

## When the user asks for status

Check and report:

1. **Token**: Read `~/.claude/channels/telegram/.env` — is `TELEGRAM_BOT_TOKEN` set?
2. **Access**: Read `~/.claude/channels/telegram/access.json` — what's the DM policy? How many users allowed?
3. **Binary**: Check if hdcd-telegram is installed (look for the binary in `~/.claude/plugins/data/hdcd-telegram/`)
4. **Groups**: List configured groups and their policies

## When the user asks "how do I set this up"

Walk them through:

1. Create a bot via @BotFather on Telegram (`/newbot`)
2. Run `/telegram:configure <token>` with the token BotFather gives
3. Restart Claude Code: `claude --dangerously-load-development-channels server:telegram`
4. DM the bot on Telegram — it replies with a pairing code
5. Run `/telegram:access pair <code>`
6. Done — next DM reaches the assistant

## For group chats

Remind the user:
- Disable privacy mode in @BotFather: `/setprivacy` → select bot → Disable
- Privacy mode must be disabled BEFORE adding bot to the group
- Promote bot to admin in the group
- Someone must send a message for the bot to register the chat_id

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `TELEGRAM_BOT_TOKEN` | (required) | Bot token from @BotFather |
| `TELEGRAM_STATE_DIR` | `~/.claude/channels/telegram` | State directory |
| `WHISPER_MODEL` | `small` | Whisper model for voice transcription |
| `WHISPER_LANGUAGE` | auto-detect | Language hint for Whisper |

## Notes

- The token file must have `chmod 600` permissions
- hdcd-telegram reads the token from `~/.claude/channels/telegram/.env` automatically
- No token should be stored in `.mcp.json` — only the binary path goes there
