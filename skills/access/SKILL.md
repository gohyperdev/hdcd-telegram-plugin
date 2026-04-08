---
name: access
description: Manage Telegram channel access — approve pairings, edit allowlists, set DM/group policy. Use when the user asks to pair, approve someone, check who's allowed, or change policy for the Telegram channel.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Bash(ls *)
  - Bash(mkdir *)
---

# /telegram:access — Telegram Channel Access Management

Manage who can reach the assistant through Telegram.

## State file

`~/.claude/channels/telegram/access.json`

Default (created on first use):
```json
{
  "dmPolicy": "pairing",
  "allowFrom": [],
  "groups": {},
  "pending": {}
}
```

## Commands

### pair \<code\>

Approve a pairing request. When someone DMs the bot, the bot replies with a 6-character hex code. The user tells you the code, and you run:

1. Read `access.json`
2. Find the code in `pending`
3. Move the user ID to `allowFrom`
4. Remove from `pending`
5. Write `access.json`

### list

Show current access config:
- DM policy
- Allowed user IDs
- Group policies
- Pending pairing requests

### add \<user_id\>

Add a Telegram user ID to `allowFrom` directly (skip pairing).

### remove \<user_id\>

Remove a user ID from `allowFrom`.

### policy \<pairing|allowlist|open\>

Set DM policy:
- **pairing** — strangers get a pairing code, must be approved
- **allowlist** — only `allowFrom` users can reach the assistant
- **open** — anyone can DM (not recommended)

### group \<chat_id\> allow|deny|mention

Set group policy:
- **allow** — deliver all messages from this group
- **deny** — ignore this group
- **mention** — only deliver messages that @mention the bot

## Notes

- User IDs are numeric Telegram IDs (get yours from @userinfobot)
- Pairing codes are 6-character hex, single-use
- Changes take effect immediately (the MCP server watches the file)
