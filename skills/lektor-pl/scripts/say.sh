#!/usr/bin/env bash
# Użycie: say.sh "<tekst>" | @plik.txt  <wynik.mp3>  [--voice gosia] [--speed 1.0] [--format mp3|ogg|wav] [--pause 350]
# Wymaga: LEKTOR_URL i LEKTOR_TOKEN w środowisku.
set -euo pipefail

usage() { sed -n '2,3p' "$0"; exit "${1:-1}"; }
[[ $# -ge 2 ]] || usage 1
TEXT="$1"; OUT="$2"; shift 2
VOICE=""; SPEED="1.0"; FORMAT=""; PAUSE="350"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --voice)  VOICE="${2:?}"; shift 2 ;;
    --speed)  SPEED="${2:?}"; shift 2 ;;
    --format) FORMAT="${2:?}"; shift 2 ;;
    --pause)  PAUSE="${2:?}"; shift 2 ;;
    -h|--help) usage 0 ;;
    *) echo "Nieznana opcja: $1" >&2; usage 1 ;;
  esac
done

: "${LEKTOR_URL:?Ustaw LEKTOR_URL (np. http://127.0.0.1:3920)}"
: "${LEKTOR_TOKEN:?Ustaw LEKTOR_TOKEN (token klienta z .env usługi)}"
[[ -n "$FORMAT" ]] || FORMAT="${OUT##*.}"
[[ "$FORMAT" =~ ^(mp3|ogg|wav)$ ]] || { echo "Format musi być mp3, ogg lub wav (podano: $FORMAT)" >&2; exit 1; }
[[ "$SPEED" =~ ^[0-9]+(\.[0-9]+)?$ && "$PAUSE" =~ ^[0-9]+$ ]] || { echo "Niepoprawne --speed lub --pause" >&2; exit 1; }
[[ -z "$VOICE" || "$VOICE" =~ ^[A-Za-z0-9_.-]+$ ]] || { echo "Niepoprawna nazwa głosu" >&2; exit 1; }

QUERY="format=$FORMAT&speed=$SPEED&pause_ms=$PAUSE"
[[ -z "$VOICE" ]] || QUERY="$QUERY&voice=$VOICE"
# "@plik.txt" jest obsługiwane przez curl (treść z pliku); zwykły tekst idzie wprost.
DATA=(--data-binary "$TEXT")

code="$(curl -sS -o "$OUT" -w '%{http_code}' -X POST "${LEKTOR_URL%/}/tts?$QUERY" \
  -H "Authorization: Bearer $LEKTOR_TOKEN" -H 'Content-Type: text/plain; charset=utf-8' \
  "${DATA[@]}")" || { echo "Brak połączenia z $LEKTOR_URL (czy to środowisko ma dostęp do VPS-a?)" >&2; rm -f "$OUT"; exit 2; }

if [[ "$code" != "200" ]]; then
  echo "Lektor zwrócił błąd HTTP $code: $(cat "$OUT")" >&2
  rm -f "$OUT"
  exit 3
fi
echo "OK: $OUT ($(du -h "$OUT" | cut -f1))"
