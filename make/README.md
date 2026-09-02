# Make blueprints — HDH social hand-off

Two scenarios. Import each into Make with **Create a new scenario → ⋯ → Import
Blueprint**, then attach connections and the webhook by hand (a blueprint
carries structure, never credentials).

- `01-review-draft.json` — receives Claude's webhook, guards against
  placeholders, emails Giusi the draft with approve / reject links.
- `02-publish-approved.json` — receives the approve click, fans out to the
  platforms.

Split in two on purpose: Make has no free-tier "wait for a human" module, so
approval is a second webhook the email links to. It also keeps the publishing
credentials in a scenario that only ever runs after a human clicked approve.

## After importing

1. In scenario 1, open the webhook module → **Add** a new custom webhook, name
   it `hdh-social-draft`. Copy its URL.
2. Put that URL in the environment as `MAKE_WEBHOOK_URL` where
   `generate-social-post` runs. **Never commit it** — anyone holding it can
   inject a post into the review queue.
3. In scenario 2, do the same for a webhook named `hdh-social-approve`, then
   paste its URL into scenario 1's email module in place of
   `<<APPROVE_WEBHOOK_URL>>`.
4. Attach connections in scenario 2's three platform modules.
5. Send a test payload before turning either scenario on.

## Platform reality — read before planning the other two channels

Of the five channels in the caption drafts, **three can be automated and two
cannot**, and this is a limit of the platforms, not of Make:

| Channel | Automatable | Module |
|---|---|---|
| Instagram | yes — business/creator account required | `instagram-business: CreateCarouselPhoto` |
| Facebook **Page** | yes | `facebook-pages: CreatePostWithPhotos` |
| Telegram channel | yes | `telegram: SendMediaGroup` |
| Facebook **personal profile** | **no** | Meta's API does not allow publishing to a personal profile |
| Facebook **Group** | **no** | Meta deprecated Groups publishing permissions |
| YouTube **community post** | **no** | YouTube's API exposes no community-post endpoint |

So the Facebook-profile, Group and YouTube captions stay a **copy-paste
deliverable**: the review email carries them in full so Giusi can post them by
hand in a couple of minutes. That is why the email includes every caption, not
only the automated ones.

If Giusi posts to a Facebook *Page* rather than her personal profile, the
`facebook_profilo` caption maps straight onto it and that channel becomes
automated — worth confirming which one she actually uses.

## Not yet validated

Both blueprints pass Make's structural schema check. Module-level validation
(that each module's parameters are right for her account, and which platform
connections already exist) needs her Make **teamId**, which this session has no
tool to look up. Ask her for it, or read it from any Make URL:
`https://eu2.make.com/<teamId>/scenarios`.
