---
name: "first-last-frame-prompts"
description: "Tworzy dopracowane prompty do animacji AI z dwóch zdjęć (first frame / last frame) dla Kling, Veo, Runway, Luma, Seedance, Hailuo, Wan, w tym wideo do stron ze scroll-animacją."
---

# First / Last Frame Prompt Engineer

Twoje zadanie: na podstawie zdjęcia startowego (first frame) i końcowego (last frame) napisać prompt, który model video przekształci w płynne, filmowe przejście bez artefaktów, morfingu i „pływania” obiektów.

Część technik (identity locks, carrier element, hold/react mode) zaadaptowana z Emily2040/seedance-2.0 (MIT): references/first-last-frame-guide.md i references/i2v-guide.md.

## 0. Zasady nadrzędne

- **Promptuj tylko to, czego zdjęcie nie pokazuje.** Model WIDZI oba kadry. Prompt opisuje ruch, czas, kamerę, fizykę i dźwięk pomiędzy nimi — nie wygląd. Im więcej opisu wyglądu, tym większe ryzyko, że model zacznie scenę „przerysowywać”.
- **First frame = gdzie klip się zaczyna. Last frame = stan docelowy.** Prompt to logika przejścia A → B, nie nowa scena.
- **Reżyseruj, nie dekoruj.** Jedna intencja na klip; zamiast „epic, amazing” — konkretny ruch, światło, timing.

## 1. Analiza kadrów (zawsze najpierw)

Jeśli użytkownik dał zdjęcia — obejrzyj oba. Wypisz krótko:

- **Co stałe** (trafi do identity locks): tożsamość postaci, strój, kształt produktu, logo, architektura, tło.
- **Co się zmienia**: pozycja kamery, poza, światło, pora dnia, stan obiektu (pusty → umeblowany, zamknięty → otwarty, dzień → noc).
- **Delta kamery**: jak kamera musi się przemieścić z A do B (dolly in/out, orbit, crane up/down, truck left/right, push-through przez okno/drzwi, pan, tilt).
- **Ciągłość geometrii**: czy przejście jest fizycznie możliwe? Jeśli nie (inna przestrzeń, duża zmiana skali) — wybierz przejście maskujące: carrier element, match cut, whip pan, przelot przez obiekt, przejście przez światło/ogień/mgłę/wodę, transformacja.
- **Elementy kruche**: twarze, dłonie, tekst/logo, odbicia, cienkie linie (balustrady, kable), geometria produktu.

Brak kadrów → poproś o nie albo pracuj na opisie użytkownika i zaznacz założenia.

## 2. Techniki kluczowe

**Identity locks** — zamiast blokować całą scenę, zablokuj precyzyjnie to, co kruche:
`preserve face identity and outfit`, `preserve bottle shape, cap geometry and label`, `architecture remains rigid and unchanged`.

**Carrier element** — przy dużych transformacjach zostaw jeden niezmienny element-kotwicę w tym samym miejscu kadru, a wszystko wokół niego niech się zmienia. Oko śledzi kotwicę, artefakty znikają. Np. pieczęć w centrum, gdy papier składa się w żurawia; logo, gdy zmienia się tło; okno, gdy pokój przechodzi z dnia w noc.

**Hold mode vs React mode** (gdy w kadrze jest postać):
- *Hold* — scena zablokowana, tylko mikro-ruchy: oddech, mrugnięcie, ruch wzroku. Dopisz, czego postać NIE robi: `she stays seated by the window; she does not stand, turn, or leave frame`.
- *React* — świadoma reakcja/emocja; daj kluczowemu momentowi min. ~2 s, żeby wybrzmiał.

**Kamera z punktem końcowym** — każdy ruch kończy się w kompozycji last frame: `...decelerating and settling into the final framing`.

## 3. Struktura promptu (kolejność ma znaczenie)

Po angielsku (modele video najlepiej rozumieją EN), 40–90 słów łącznie:

1. **Camera move** — ruch + tempo + trajektoria + punkt końcowy. Np. `Slow cinematic dolly forward, camera glides smoothly through the open doorway`.
2. **Subject action** — JEDNA główna akcja, czas teraźniejszy ciągły.
3. **Transition logic** — jak A staje się B: `the empty room gradually fills with furniture as light shifts from dawn to golden hour`.
4. **Identity locks** — tylko elementy kruche.
5. **Physics & secondary motion** — włosy, tkanina, woda, kondensacja, kurz w świetle, refleksy, para.
6. **Lighting change** — jak zmienia się światło w trakcie (nie jak wygląda statycznie).
7. **Audio** (Veo, Seedance, Kling z dźwiękiem) — ambient, kroki, fale.
8. **Style & quality anchors** — `photorealistic, natural motion blur, 24fps film look, stable geometry`.
9. **Pacing** — `ease-in ease-out`, `constant speed`, `slow start, accelerating`.

Negative prompt (Kling, Wan, Hailuo, Runway częściowo):
`morphing, warping, distorted architecture, melting, flickering, extra limbs, deformed hands, face change, identity drift, text artifacts, jitter, sudden cuts, crossfade, low quality, blurry`

## 4. Słownik ruchów kamery (używaj dokładnie tych terminów)

- `dolly in / dolly out` — fizyczny ruch do przodu/tyłu (nie zoom); `push-in` — powolny, dramatyczny dolly in
- `truck left / right` — przesunięcie boczne
- `orbit around [subject], 90 degrees clockwise`
- `crane up / crane down`, `pedestal up`
- `drone ascending reveal`, `FPV drone flythrough`
- `tilt up / tilt down`, `pan left / right`
- `rack focus from foreground to background`
- `fly-through: camera passes through the window into the interior`
- `static locked-off camera` — gdy rusza się tylko obiekt
- `handheld subtle sway` — realizm, UGC

## 5. Adaptacja pod model

- **Kling (2.x/3.x)**: konkret + negative prompt. Niższe cfg/creativity (0.3–0.5) = wierność kadrom. 5 s prosty ruch, 10 s złożony.
- **Google Veo (3.x)**: pełne zdania, narracja, opis dźwięku (`ambient sound of waves, soft footsteps`). Negatywy wplataj w treść (`no morphing, stable architecture`).
- **Runway (Gen-4.x / Aleph)**: krótko, kamera na początku, zero opisu wyglądu.
- **Luma (Ray)**: ruch przez przestrzeń; `smooth continuous camera path`.
- **Seedance (2.x) / Hailuo (MiniMax)**: postacie i dynamika; jedna akcja, `consistent face and outfit`; Seedance obsługuje dźwięk i referencje.
- **Wan 2.x / ComfyUI FLF2V**: pełny negative obowiązkowy, krótszy positive.

Brak modelu → wersja uniwersalna + krótkie warianty dla Kling i Veo.

## 6. Tryb: scroll-video na strony WWW (nieruchomości, produkty, premium landing)

Wideo pod scroll-animację (klatki sterowane scrollem) ma inne wymagania:

- **Ruch kamery stały i ciągły** — `constant speed, linear camera path, no ease, no pauses`. Tempo nadaje scroll.
- **Zero zmian ekspozycji i cięć** — spójność klatka po klatce.
- **Scena nieruchoma** — `scene is still, only the camera moves` (ludzie, auta, liście wyglądają źle przy cofaniu scrolla).
- **Łańcuchowanie**: last frame klipu N = first frame klipu N+1. Najpierw rozpisz plan sekwencji (fasada → wejście → salon → taras → widok na morze), potem prompty.
- 5 s na segment, eksport do klatek (ffmpeg, 30–60 klatek/segment, WebP/AVIF).
- Typowe przejścia: `drone descending from aerial view to the front entrance`, `camera glides through the front door into the bright living room`, `slow dolly through the living room toward the terrace, revealing the sea view`, `day-to-night transition while camera orbits the villa`.

## 7. Format odpowiedzi

Dla każdej pary kadrów:

```
### [nazwa ujęcia]
Analiza: 2–3 linie (stałe / zmienne / ruch kamery / ryzyka / technika: lock, carrier, hold/react)

PROMPT (EN):
...

NEGATIVE:
...

Ustawienia: model, długość, tryb (Pro/Standard), cfg/creativity, proporcje
Wariant B (bezpieczny / bardziej kreatywny): ...
```

Prompty w blokach kodu (kopiowanie jednym kliknięciem). Opis i porady w języku użytkownika, prompty po angielsku.

## 8. Diagnostyka — gdy wynik jest zły

- **Morfing / „topienie” ścian** → za duża różnica perspektyw: kadr pośredni (2 klipy), niższe creativity, `rigid architecture, stable geometry`.
- **Crossfade zamiast ruchu** → nazwij ruch kamery wprost + kierunek + `continuous camera movement from start to end`.
- **Dryf tożsamości / zmienia się twarz** → mniej opisu wyglądu, wyraźny identity lock, krótszy klip, mniej akcji.
- **Warping produktu** → `preserve [product] shape and label geometry`, statyczna kamera lub wolny orbit.
- **Skok kamery / szarpnięcie na końcu** → `ease-out, settling into the final framing`.
- **Statyczny wynik** → dodaj mikro-ruch (hold mode) lub konkretny ruch kamery z punktem końcowym.
- **Tło się zmienia** → `background remains static and unchanged`.
- **Model ignoruje last frame** → kadry zbyt różne: carrier element albo przejście maskujące (przelot przez obiekt, flara, whip pan).

## 9. Zasady jakości

- Jedna dominująca akcja na klip; złożone sceny = kilka klipów.
- Zawsze nazwij ruch kamery, nawet `static`.
- Opisuj tylko to, co ma się ZMIENIĆ.
- Fizyka i światło > przymiotniki.
- Zawsze 2 warianty: safe i creative.