# remotion-plugin

Claude Code / Cowork plugin that wraps the Remotion skill. Use it to generate React-based programmatic videos.

## Install in Cowork

1. Zip this folder.
2. In the Claude desktop app, open Cowork settings → Plugins → Upload.
3. Drop in `remotion-plugin.zip`.

## Local test (Claude Code)

```
claude --plugin-dir ~/Desktop/cowork-plugins/remotion-plugin
```

## What's inside

- `skills/remotion/SKILL.md` — main skill
- `skills/remotion/references/` — components, animations, rendering guides
- `skills/remotion/scripts/init_remotion.sh` — bootstrap a new Remotion project
