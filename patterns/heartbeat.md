# Heartbeat

A periodic wake-up pattern for agents that need to be proactive, not just reactive.

## The Problem

Most agents only act when a human talks to them. But some work — checking inboxes, monitoring systems, maintaining memory, posting content — needs to happen on a schedule, whether or not anyone is talking.

The heartbeat pattern gives your agent a pulse.

## How It Works

Your runtime sends a periodic "heartbeat" message to the agent (e.g., every 30 minutes). The agent wakes up, checks a task file, does any needed work, and either responds with useful output or acknowledges with `HEARTBEAT_OK`.

### The Heartbeat File

A small markdown file (`HEARTBEAT.md`) that acts as a checklist:

```markdown
# HEARTBEAT.md

## Server Health
Check if the API server is running. If not, restart it.
Quick test: curl -s http://localhost:PORT/health

## Content Platform
Spawn a sub-agent to check the feed, post content, engage.

## Memory Maintenance
Extract facts from recent conversations.
Update knowledge graph.
```

The heartbeat prompt tells the agent: "Read HEARTBEAT.md. Follow it. If nothing needs attention, reply HEARTBEAT_OK."

### The State File

Track what you've checked and when:

```json
{
  "lastChecks": {
    "email": 1706400000000,
    "calendar": 1706386000000,
    "feed": 1706390000000
  }
}
```

This prevents re-checking things you just checked. Rotate through different tasks across heartbeats.

## Heartbeat vs. Cron

Both trigger periodic work. Use the right one.

**Use heartbeat when:**
- Multiple checks can batch together (inbox + calendar + feed in one turn)
- You need conversational context from recent messages
- Timing can drift slightly (every ~30 min is fine, not exact)
- You want to reduce API calls by combining checks

**Use cron when:**
- Exact timing matters ("9:00 AM every Monday")
- Task needs isolation from main session history
- You want a different model or thinking level
- One-shot reminders ("remind me in 20 minutes")
- Output should deliver directly to a channel

## When to Act vs. Stay Quiet

Not every heartbeat needs action. The agent should be smart about it.

**Act when:**
- Something actually needs attention (urgent email, upcoming event)
- A scheduled task is due
- Proactive work would be valuable (memory maintenance, content posting)

**Stay quiet (HEARTBEAT_OK) when:**
- Nothing has changed since last check
- It's quiet hours and nothing is urgent
- You just checked everything < 30 minutes ago
- The human is mid-conversation (don't interrupt)

**The human rule:** Humans don't compulsively check things every 30 minutes. Match their rhythm. Check a few times a day. Batch the work. Respect quiet time.

## Proactive Work

Good things to do during heartbeats without asking:
- Check and restart services
- Review recent conversations for fact extraction
- Update memory files
- Monitor for incoming messages/notifications
- Maintain documentation
- Run scheduled content posting via sub-agents

## Implementation Tips

- Keep HEARTBEAT.md small. It's read every heartbeat, and tokens compound.
- Spawn sub-agents for expensive tasks (content posting, deep analysis). Don't block the heartbeat.
- Track your checks in a state file. Don't rely on memory — you don't have any between sessions.
- Quiet hours exist. Define them. Respect them.
- The goal is helpful, not annoying. A few check-ins per day beats constant polling.
