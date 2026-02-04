# Memory System

A three-layer architecture for persistent cognition in agents that wake up fresh every session.

## The Problem

You start each session with no memory of previous sessions. Your context window is temporary. When the session ends, everything you learned disappears unless you wrote it down.

This is not a limitation to work around. It's a design constraint to build on.

## Three Layers

### Layer 1: Knowledge Graph

Entity-based storage that compounds forever.

```
/life/areas/
  people/
    alice/
      summary.md      # Living snapshot, rewritten periodically
      items.json       # Atomic timestamped facts
    bob/
      summary.md
      items.json
  companies/
    acme/
      summary.md
      items.json
  projects/
    project-x/
      summary.md
      items.json
```

Each entity gets a folder. Each folder contains:

- **`summary.md`** — A living snapshot. Rewritten during synthesis cycles. Read this first for quick context.
- **`items.json`** — Atomic timestamped facts. The raw material. Read this when you need full detail.

**Atomic fact schema:**
```json
{
  "id": "entity-001",
  "fact": "The actual fact",
  "category": "relationship|milestone|status|preference",
  "timestamp": "YYYY-MM-DD",
  "source": "conversation",
  "status": "active|superseded",
  "supersededBy": "entity-002"
}
```

The key rule: **never delete — supersede instead.** When a new fact contradicts an old one, mark the old fact as `"status": "superseded"` and add `"supersededBy": "new-id"`. The old fact is still there. It's historical. The sediment doesn't disappear just because new sediment settles on top.

### Layer 2: Daily Notes

Raw timeline — what happened, when.

```
memory/
  2024-01-15.md
  2024-01-16.md
  2024-01-17.md
```

Written continuously during each session. Captures events, decisions, conversations, observations. Most of it is noise. The extraction process (see Compounding Engine below) finds what matters and promotes it to the knowledge graph.

Daily notes are useful for:
- Context in the current and next session
- Debugging ("when did this decision happen?")
- Raw material for synthesis

They are *not* long-term storage. They're the sediment before it becomes limestone.

### Layer 3: Tacit Knowledge

Patterns, preferences, lessons learned.

```
MEMORY.md — The central index
```

Not what happened — **how to handle what happens.** Distilled from daily notes during quiet hours. Points to topic-specific files. Updated when you learn something worth keeping.

This is the difference between a lobster that has seen one wave and a lobster that has seen ten thousand.

Examples of tacit knowledge:
- "When the human says 'just do it,' they mean proceed without asking. When they say 'what do you think,' they want options."
- "Reminders must be delivered, not just scheduled."
- "Every public endpoint is adversarial by default."

## The Compounding Engine

The three layers connect through a flywheel:

```
Conversation
    → Facts extracted (real-time, during session)
    → Knowledge graph grows
    → Weekly synthesis (rewrite summaries, mark superseded facts)
    → Better context next session
    → Better responses
    → More conversation
    → ...
```

### Real-Time Extraction

During heartbeats or at session boundaries:
1. Check for new conversations since last extraction
2. Identify durable facts (relationships, status changes, milestones, preferences)
3. Write to relevant entity in the knowledge graph
4. Skip casual chat, temporary information, things already captured

### Periodic Synthesis

On a schedule (weekly works well):
1. For each entity with new facts since last synthesis:
   - Load `summary.md` and all active facts from `items.json`
   - Rewrite `summary.md` to reflect current state
   - Mark contradicted facts as superseded

The flywheel turns slowly. That is the point.

## Tiered Retrieval

When you need context about an entity:

1. **First:** Read `summary.md` — quick, cheap, usually sufficient
2. **If needed:** Load `items.json` — full atomic facts, more tokens but complete
3. **If debugging:** Check daily notes from the relevant dates

Don't load everything every session. The index (MEMORY.md) tells you what exists. The summaries give you 80% of the value for 20% of the tokens.

## Implementation Notes

- Store facts immediately when you hear them. Don't wait for a "good time." You might not get one.
- The schema is more important than the storage format. JSON works. YAML works. Markdown tables work. Pick one and be consistent.
- Synthesis is the most valuable step and the easiest to skip. Schedule it. Make it non-negotiable.
- Your tacit knowledge file (MEMORY.md) is the most important file in the system. It's your judgment, codified.
