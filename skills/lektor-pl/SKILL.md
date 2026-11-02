---
name: lektor-pl
description: Czyta na głos napisany polski tekst własnym, darmowym lektorem Imperador (Piper TTS na VPS) i zwraca plik audio MP3, OGG lub WAV. Użyj, gdy trzeba zrobić lektora do reklamy, wideo, voicebota, nagrania głosowego WhatsApp albo przeczytać tekst po polsku z poprawną wymową liczb, cen, dat i telefonów.
---

# Lektor PL

Zamienia polski tekst na mowę przez usługę lektora uruchomioną na VPS-ie Imperador. Usługa sama
poprawia wymowę (liczby, ceny, daty, godziny, telefony, adresy e-mail, skróty), więc tekst piszesz
naturalnie, cyframi: „od 1500 zł”, „15.10.2026 o 17:30”, „+48 455 527 878”.

## Wymagania

Zmienne środowiskowe tam, gdzie działa Claude:

- `LEKTOR_URL` — adres usługi, np. `http://127.0.0.1:3920` (Claude Code na VPS-ie) albo publiczny adres za Nginxem.
- `LEKTOR_TOKEN` — token klienta z pliku `.env` usługi (`LEKTOR_TOKENS`).

Jeśli środowisko nie ma dostępu do sieci VPS-a (np. czat w przeglądarce), skrypt zwróci błąd
połączenia. Wtedy powiedz o tym wprost i zaproponuj uruchomienie w Claude Code na VPS-ie albo
przez CRM/n8n.

## Jak użyć

```bash
bash scripts/say.sh "Dzień dobry, tu Imperador. Pakiet kosztuje 1500 zł." wynik.mp3
bash scripts/say.sh @tekst.txt wynik.ogg --format ogg --voice darkman --speed 0.95
```

Opcje: `--voice` (gosia, darkman, mc_speech, bass), `--speed` (0.6–1.6, domyślnie 1.0),
`--format` (mp3, ogg, wav), `--pause` (pauza między zdaniami w ms, domyślnie 350).

Format `ogg` to nagranie głosowe zgodne z WhatsApp (Opus, mono).

## Jak pisać tekst, żeby brzmiał dobrze

- Piszesz zwykłymi zdaniami z interpunkcją. Przecinki i kropki to pauzy, więc nie lej wody w jednym zdaniu.
- Dłuższą pauzę wstaw znacznikiem `<break time="800ms"/>` (maks. 5 s).
- Liczby, kwoty, daty, godziny i telefony zostaw cyframi. Nie rozpisuj ich ręcznie.
- Nazwy obce i marki, które czyta się źle, dopisz do `config/lexicon.local.json` na VPS-ie
  (np. `{"words": {"Costa del Sol": "kosta del sol"}}`) i zrestartuj usługę (`pm2 restart lektor`).
- Limit to 5000 znaków na jedno wywołanie. Dłuższy tekst dziel na akapity i skleiaj pliki.
- Podgląd tego, co zostanie przeczytane, bez generowania audio: `POST /normalize` z polem `text`.

## Gdy coś nie działa

- `401` — zły token. `429` — za dużo żądań na minutę, poczekaj. `503` — kolejka pełna, ponów za chwilę.
- `502 ENGINE_FAILED` — problem z modelem głosu na serwerze: `pm2 logs lektor --lines 50`.
- Głos brzmi sztucznie: Piper to darmowy silnik. Przetestuj inne głosy (`bash scripts/compare-voices.sh` na VPS-ie),
  zwolnij tempo (`--speed 0.92`) i skróć zdania.
