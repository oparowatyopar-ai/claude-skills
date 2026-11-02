# claude-skills

Osobne repozytorium ze skillami i komendami dla Claude'a (poza projektem imperador-ai).

Struktura:

- `skills/<nazwa-skilla>/SKILL.md` - skille (laduja sie z `~/.claude/skills/`)
- `commands/<nazwa>.md` - komendy slash (laduja sie z `~/.claude/commands/`)

## Skille

Wlasne:

- `normalizacja-tresci-stron` - usuwanie AI slopu z tekstow stron (PL / ES / EN)
- `porownanie-stron-budowlanych` - porownanie strony firmy remontowo-budowlanej z konkurencja
- `komendy-animacje` - sciaga: jakich komend i skilli uzyc do animowanych stron i wideo
- `first-last-frame-prompts` - prompty do animacji AI z dwoch klatek (Kling, Veo, Runway, Luma...)
- `scroll-video-site` - strony z wideo sterowanym scrollem (ffmpeg + canvas + GSAP)
- `scrub` - sekcja hero z wideo przewijanym scrollem
- `lektor-pl` - polski lektor (Piper TTS na VPS-ie Imperador); wymaga `LEKTOR_URL` i `LEKTOR_TOKEN`

Zewnetrzne (skopiowane, zrodla maja wlasne licencje):

- `gsap-performance`, `gsap-react`, `gsap-scrolltrigger` - oficjalne skille GSAP
- `refero-design` - research-first UI/UX design (Refero)
- `nano-banana` - generowanie obrazow przez Gemini CLI
- `agent-browser` - automatyzacja przegladarki
- `find-skills` - wyszukiwanie skilli
- `dreamina-canvas-cli` - Dreamina canvas CLI

## Komendy

`algorytmy-shortform`, `analiza-biznesu`, `audyt-video`, `generuj`, `komunikat-modul1`,
`meta-ads`, `oswietlenie-ai`, `pakiet-kreacji`, `prompt-architect`, `przerob-kreacje`, `sprzedaz`

## Instalacja

    git clone https://github.com/oparowatyopar-ai/claude-skills.git ~/ai/claude-skills
    mkdir -p ~/.claude/skills ~/.claude/commands
    for s in ~/ai/claude-skills/skills/*/; do ln -s "${s%/}" ~/.claude/skills/; done
    for c in ~/ai/claude-skills/commands/*.md; do ln -s "$c" ~/.claude/commands/; done

Symlinki sprawiaja, ze po `git pull` skille sa od razu aktualne, bez kopiowania.

## Pluginy (instalowane osobno, nie ma ich w tym repo)

W Claude Code:

    /plugin marketplace add coreyhaines31/marketingskills
    /plugin install marketing-skills@marketingskills
    /plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
    /plugin install ui-ux-pro-max@ui-ux-pro-max-skill
    /plugin marketplace add AgriciDaniel/claude-seo
    /plugin install claude-seo@agricidaniel-claude-seo

`ui-ux-pro-max` daje tez skille `banner-design`, `brand`, `design`, `design-system`, `slides`, `ui-styling`.
