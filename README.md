# claude-skills

Osobne repozytorium ze skillami dla Claude'a (poza projektem imperador-ai).

Struktura: `skills/<nazwa-skilla>/SKILL.md`

## Skille

- `normalizacja-tresci-stron` - usuwanie AI slopu z tekstow stron (PL / ES / EN)

## Uzycie w Claude Code

Skille laduja sie z `~/.claude/skills/`. Zamiast kopiowac, podlinkuj je z tego repo:

    ln -s ~/ai/claude-skills/skills/normalizacja-tresci-stron ~/.claude/skills/normalizacja-tresci-stron

Po zmianie w repo skill jest od razu aktualny (symlink), bez kopiowania.
