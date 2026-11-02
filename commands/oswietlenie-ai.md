# Oświetlenie AI — NanoBanana + Kling 3.0

Generuje prompt do NanoBanana dla wybranego stylu oświetlenia, który następnie nakładasz na wideo w Kling 3.0.

**Użycie:** `/oswietlenie-ai [styl]`

Dostępne style: `rembrandt`, `teal-orange`, `high-key`, `god-rays`, `golden-hour`, `cyberpunk`

Bez argumentu — wyświetla wszystkie 6 promptów naraz.

---

## Instrukcja dla Claude

**Workflow:**
1. Nagraj wideo (lub masz już gotowe)
2. Zrób screenshot z wideo — kadr z twarzą / postacią
3. Wklej screenshot do **NanoBanana** z wybranym promptem poniżej → generujesz "Image 1" (referencja oświetlenia)
4. Wklej oryginalne wideo + Image 1 do **Kling 3.0**
5. Wpisz komendę: `Video 1 with the lighting of Image 1`

---

## Argument użytkownika: $ARGUMENTS

Jeśli użytkownik podał styl — podaj tylko ten jeden prompt + instrukcję użycia.
Jeśli nie podał niczego — wyświetl wszystkie 6 promptów.

---

## 6 PROMPTÓW DO NANOBANANA

### 1. REMBRANDT — Dramatyczny portret kinowy
```
Cinematic Rembrandt lighting portrait. One side of the face dramatically lit, 
the other in deep shadow. Triangle of light under eye. Dark, moody background. 
Chiaroscuro effect. Film photography, high contrast.
```
*Efekt: Jedna strona twarzy oświetlona, druga w głębokim cieniu. Mroczny klimat. Idealny do contentu eksperckiego i autorytetu.*

---

### 2. TEAL & ORANGE — Hollywood blockbuster
```
Cinematic teal and orange color grading. Warm orange skin tones, 
cool teal shadows. Hollywood blockbuster look. High contrast, 
rich saturation. Professional film color grade.
```
*Efekt: Ciepłe pomarańczowe odcienie skóry, chłodne turkusowe cienie. Wygląda jak trailer filmowy.*

---

### 3. HIGH KEY — Czysto i nowocześnie
```
High-key studio lighting, soft white background, clean and modern, 
minimal shadows, bright and airy, professional photography, 
commercial style, crisp and clear.
```
*Efekt: Jasne, czyste, profesjonalne. Dobre do marek premium, produktów, lifestyle.*

---

### 4. GOD RAYS — Promienie słońca przez okno
```
Cinematic god rays lighting, volumetric light beams coming from upper left, 
dusty atmosphere, dramatic sunlight through window, 
warm golden haze, film noir mood.
```
*Efekt: Dramatyczne promienie światła z góry. Atmosferyczny, filmowy klimat.*

---

### 5. GOLDEN HOUR — Magiczne popołudnie
```
Golden hour sunset lighting, warm amber glow, long soft shadows, 
magical hour light, cinematic outdoor scene, rich warm tones, 
beautiful natural backlight.
```
*Efekt: Ciepłe złote światło zachodzącego słońca. Naturalny, lifestyle'owy klimat.*

---

### 6. CYBERPUNK — Neonowe miasto
```
Cyberpunk neon lighting, electric blue and magenta neon reflections, 
rain-wet surfaces, futuristic urban night scene, high contrast, 
vivid synthetic colors, blade runner aesthetic.
```
*Efekt: Niebieski + magenta neon. Futurystyczny, nocny, technologiczny klimat. Idealne dla AI/tech marek.*

---

## WSKAZÓWKA

Który styl do jakiego celu:
- **Rembrandt** → edukacja, ekspert, autorytet, mentoring
- **Teal & Orange** → lifestyle, aspiracyjny content, sprzedaż premium
- **High Key** → produkt, marka osobista, profesjonalizm
- **God Rays** → emocjonalny content, historia, transformacja
- **Golden Hour** → relacje, lifestyle, naturalność, warmth
- **Cyberpunk** → AI, tech, innowacja, futuryzm
