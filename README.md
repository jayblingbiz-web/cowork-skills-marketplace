# jayblingbiz-cowork-skills

Personal Claude Code plugin marketplace. Bundles four custom plugins for video creation, image generation, and skill scaffolding.

## Install

In Claude Code:

```
/plugin marketplace add jayblingbiz-web/cowork-skills-marketplace
```

Then install whichever plugins you want:

```
/plugin install remotion-plugin@jayblingbiz-cowork-skills
/plugin install skill-creator-plugin@jayblingbiz-cowork-skills
/plugin install ugc-video-plugin@jayblingbiz-cowork-skills
/plugin install trending-news-plugin@jayblingbiz-cowork-skills
```

Once installed, the plugins surface in **both Claude Code and Cowork sessions** automatically. Type `/` in any chat and you'll see them.

## Plugins

| Plugin | What it does |
|---|---|
| `remotion-plugin` | Programmatic video creation with Remotion |
| `skill-creator-plugin` | Scaffold, validate, and package Claude skills |
| `ugc-video-plugin` | UGC-style ad videos (Flux 2 Pro + MiniMax Hailuo). Requires `FAL_KEY` |
| `trending-news-plugin` | Trending-news character videos (HeyGen + ElevenLabs + X). Requires `X_BEARER_TOKEN`, `HEYGEN_API_KEY`, optional `ELEVENLABS_API_KEY` |
