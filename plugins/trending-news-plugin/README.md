# trending-news-plugin

Cowork plugin that bundles the trending-news-character-skill and safezone-template-reference sub-skills for generating news-style avatar videos.

## ⚠ Important caveat

The original skill expects a project layout with sibling `config/`, `platforms/`, `memory/`, etc. directories at `{baseDir}/../../../`. Inside a plugin those parent paths don't exist, so the SKILL.md needs editing to read configs relative to the plugin's own `skills/<name>/` dir, **or** Claude needs to be launched from inside the full project pack at `~/Desktop/trending-news-character-skill/`.

For Cowork specifically: this plugin gives Claude the skill prompts and scripts, but you'll still need to provide `config/*.json` and `.env` values inside whatever Cowork project you run it in.

## Install in Cowork

1. Zip this folder.
2. In the Claude desktop app, open Cowork settings → Plugins → Upload.
3. Drop in `trending-news-plugin.zip`.

## Local test (Claude Code)

```
claude --plugin-dir ~/Desktop/cowork-plugins/trending-news-plugin
```

## Required env vars

- `X_BEARER_TOKEN` — for X/Twitter research
- `HEYGEN_API_KEY` — avatar video generation
- `ELEVENLABS_API_KEY` (optional) — voice if not using HeyGen voice
- `ELEVENLABS_VOICE_ID` (optional) — paired with the above

## What's inside

- `skills/trending-news-character-skill/` — main skill + subskills (viral-script, viral-research, hyperframes-video, talking-video)
- `skills/safezone-template-reference/` — reference template skill with the same subskill structure
