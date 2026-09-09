# Approved social posts

**Committed, unlike `out/`.** This is the durable record of what Giusi actually
approved — one `.md` (the captions as approved) and one `.json` (the payload)
per post.

Written by two different triggers, both keyed to a real approval signal, never
to a draft being produced:

- `schedule-social-post` writes (or confirms) the pair when Giusi says, in
  conversation, that a specific post is approved and ready to send — this is
  the only path that also POSTs to Make.
- `generate-social-post` (step 0) syncs the pair automatically from Canva
  before every run, for any design in the current or previous month's
  subfolder of `Social Media Automation` whose title carries Giusi's
  scheduling-date prefix (e.g. `10.9 at 9 pm ...`) — dating a design in
  Canva herself is the same approval signal, just read back from Canva
  instead of spoken in a session. This path is read-only against Canva and
  never touches Make; it exists so the reference set here (also what
  `social-critic` scores drafts against) doesn't lag behind what she's
  actually approved. It only looks at the last two months by default, so a
  post dated well outside that window needs a one-off resync rather than
  showing up automatically.

Don't hand-edit these to change copy — the point is that they record what was
approved, not what someone wishes had been. To change a post, redraft it,
have Giusi re-date or re-approve it, and let the file resync.
