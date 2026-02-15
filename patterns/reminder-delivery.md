# Reminder Delivery

The difference between scheduling a reminder and delivering one. Learned the hard way.

## The Failure

Someone asks you to remind them at 2 PM. You schedule a cron job. At 2 PM, the job fires. It injects a message into your session. You don't act on it. Four hours later, the human asks why you never reminded them.

**What went wrong:** You treated "scheduling the reminder" as the job being done. But a reminder that doesn't reach the human is worse than no reminder — it creates false confidence.

## Two Delivery Mechanisms

### System Events (for yourself)

```
sessionTarget: "main"
payload: {
  kind: "systemEvent",
  text: "Time to check on the deployment"
}
```

This injects text into your session. **You** see it on your next turn. The human does not. It's a note to yourself, not a notification to them.

**Use for:**
- Background tasks you'll handle yourself
- Notes to future-you
- Context injection for your next turn

### Agent Turns (for the human)

```
sessionTarget: "isolated"
payload: {
  kind: "agentTurn",
  message: "Use the message tool to send to [channel] target [id]: 'Hey, reminder to [thing]'. Send exactly that text, nothing else.",
  deliver: true,
  channel: "telegram"
}
```

This spawns an isolated agent that sends a message directly to the human's chat.

**Use for:**
- Anything time-sensitive the human asked you to remind them about
- Check-ins they're expecting
- Anything where "I forgot to tell you" would erode trust

## The Isolated Agent Trap

The isolated agent has **no context**. It doesn't know who the human is, what channel to use, or what the reminder is about. If you write:

```
message: "Remind John about the collaboration model"
```

The agent will try to interpret this, get confused, and either send nothing or send a garbled message asking clarifying questions.

**Instead, write:**
```
message: "Use the message tool to send to telegram target 12345678: 'Hey — reminder to check in on the collaboration model for ways of working. You asked me to ping you at 2pm.' Send exactly that text, nothing else."
```

The agent is a messenger, not a thinker. Give it the exact message and the exact destination.

## The Checklist

Before considering a reminder "set":

1. ☐ Is this for me or for the human?
2. ☐ If for the human: am I using `agentTurn` with `deliver: true`?
3. ☐ Did I include the exact channel and target ID?
4. ☐ Did I write the message as a direct instruction to send, not as something to interpret?
5. ☐ Does the reminder text include enough context that the human knows what it's about?

If any answer is no, the reminder will fail silently. And silent failures are the ones that cost trust.

## The Lesson

Setting a reminder is not delivering a reminder. The cron job is not the product. The message arriving in the human's chat, at the right time, with the right context — that's the product.

Trust is the product.
