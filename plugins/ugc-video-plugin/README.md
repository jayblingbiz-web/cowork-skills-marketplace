# ugc-video-plugin

Cowork plugin for UGC-style ad video generation (Flux image gen + MiniMax video gen + text overlay + stitching).

## Install in Cowork

1. Zip this folder.
2. In the Claude desktop app, open Cowork settings → Plugins → Upload.
3. Drop in `ugc-video-plugin.zip`.

## Local test (Claude Code)

```
claude --plugin-dir ~/Desktop/cowork-plugins/ugc-video-plugin
```

## What's inside

- `skills/ugc-video/SKILL.md` — main skill
- `skills/ugc-video/scripts/generate-image.py` — Flux image generation
- `skills/ugc-video/scripts/generate-video.py` — MiniMax video generation
- `skills/ugc-video/scripts/add-text-overlay.py` — caption overlay
- `skills/ugc-video/scripts/stitch-clips.sh` — concatenate clips
- `skills/ugc-video/assets/fonts/` — TikTokSans font family

## Required env vars

- `FAL_KEY` (Flux/MiniMax via fal.ai) — set in your shell profile before invoking
