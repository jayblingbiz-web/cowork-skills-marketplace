# skill-creator-plugin

Cowork plugin that scaffolds, validates, and packages Claude skills.

## Install in Cowork

1. Zip this folder.
2. In the Claude desktop app, open Cowork settings → Plugins → Upload.
3. Drop in `skill-creator-plugin.zip`.

## Local test (Claude Code)

```
claude --plugin-dir ~/Desktop/cowork-plugins/skill-creator-plugin
```

## What's inside

- `skills/skill-creator/SKILL.md` — main skill
- `skills/skill-creator/scripts/init_skill.py` — scaffold new skill
- `skills/skill-creator/scripts/package_skill.py` — bundle a skill
- `skills/skill-creator/scripts/quick_validate.py` — sanity-check structure
