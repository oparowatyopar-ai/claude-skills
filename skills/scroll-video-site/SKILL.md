---
name: "scroll-video-site"
description: "Buduje animowane strony i sekcje scroll-scrub (wideo sterowane scrollem) z klipów AI: klatki z ffmpeg, sekcja canvas + GSAP, optymalizacja i wdrożenie. Użyj przy stronach premium, demo dla inmobiliarias i reklamach produktów."
---

# Scroll Video Site

Pełny pipeline: **zdjęcia → klipy AI → klatki → sekcja scroll-scrub → strona → wdrożenie**.
Do promptów wideo używaj skilla `first-last-frame-prompts`.

## Komendy (użytkownik pisze je w czacie)

- `scroll plan <projekt>` — plan sekwencji ujęć (np. fasada → wejście → salon → taras → widok), lista zdjęć do zrobienia/zebrania, łańcuch first/last frame, teksty na każdy etap scrolla.
- `scroll prompts` — prompty wideo dla każdego segmentu (deleguj do `first-last-frame-prompts`, tryb scroll-video).
- `scroll frames <plik.mp4>` — komendy ffmpeg do wyciągnięcia i kompresji klatek (desktop + mobile).
- `scroll section` — gotowa sekcja HTML/CSS/JS (canvas + GSAP ScrollTrigger) z preloaderem i fallbackiem.
- `scroll page <branża>` — kompletna strona: hero scroll-scrub + sekcje treści + CTA (WhatsApp / formularz), PL/ES/EN.
- `scroll next` — wersja Next.js (komponent React) do Imperador-AI.
- `scroll deploy` — checklista wdrożenia (Nginx/VPS, cache, CDN, Lighthouse).
- `scroll audit <url>` — przegląd istniejącej strony scroll: płynność, waga, mobile, SEO.

Gdy użytkownik nie poda komendy, rozpoznaj etap i zaproponuj następny krok.

## 1. Plan sekwencji

- Jedna historia, 3–6 segmentów po 5–8 s. Last frame segmentu N = first frame segmentu N+1.
- Ruch kamery ciągły i liniowy, scena nieruchoma (tylko kamera się rusza) — scroll w górę odtwarza od tyłu, więc ludzie/auta/liście wyglądają źle.
- Produkty: obrót, „składanie się” (generuj rozpad i odwracaj w montażu), transformacja składników w produkt.
- Nieruchomości: dron → wejście → wnętrza → taras → widok na morze; dzień → noc na finale.
- Na każdy etap 1 nagłówek (max 6 słów) + 1 zdanie, pojawiające się przy danym progu scrolla.

## 2. Klatki (ffmpeg)

Sklej segmenty i wyciągnij klatki w dwóch rozmiarach:

```bash
# sklejenie segmentów (te same parametry)
printf "file '%s'\n" seg*.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy full.mp4

# desktop: 1920 px, 24 fps, WebP
mkdir -p frames/desktop frames/mobile
ffmpeg -i full.mp4 -vf "fps=24,scale=1920:-2" -c:v libwebp -quality 72 -compression_level 6 frames/desktop/f_%04d.webp
# mobile: 900 px, 18 fps
ffmpeg -i full.mp4 -vf "fps=18,scale=900:-2" -c:v libwebp -quality 68 frames/mobile/f_%04d.webp

# odwrócenie klipu (trik „składania”)
ffmpeg -i clip.mp4 -vf reverse -an clip_rev.mp4
# pętla przód + tył
ffmpeg -i clip.mp4 -filter_complex "[0:v]reverse[r];[0:v][r]concat=n=2:v=1[out]" -map "[out]" -an loop.mp4
```

Budżet: desktop ≤ 120–180 klatek / ≤ 8 MB łącznie; mobile ≤ 100 klatek / ≤ 4 MB. Za dużo → obniż fps, nie jakość.
Alternatywa dla bardzo długich sekwencji: jedno wideo MP4 z gop=1 (`-g 1`) i scrub przez `video.currentTime` — lżejsze, ale mniej płynne na iOS.

## 3. Sekcja scroll-scrub (wzór)

```html
<section class="scrub" id="scrub">
  <div class="scrub__sticky">
    <canvas id="scrub-canvas"></canvas>
    <div class="scrub__copy" data-from="0" data-to="0.3"><h2>Nagłówek 1</h2><p>Zdanie.</p></div>
    <div class="scrub__copy" data-from="0.35" data-to="0.7"><h2>Nagłówek 2</h2><p>Zdanie.</p></div>
    <div class="scrub__copy" data-from="0.75" data-to="1"><h2>Nagłówek 3</h2><a class="cta" href="#kontakt">CTA</a></div>
  </div>
</section>
<style>
.scrub{height:400vh;position:relative}
.scrub__sticky{position:sticky;top:0;height:100vh;height:100svh;overflow:hidden}
#scrub-canvas{width:100%;height:100%;display:block;object-fit:cover}
.scrub__copy{position:absolute;left:6vw;bottom:12vh;max-width:32rem;opacity:0;transform:translateY(20px);transition:opacity .4s,transform .4s;color:#fff;text-shadow:0 2px 20px rgba(0,0,0,.4)}
.scrub__copy.is-on{opacity:1;transform:none}
@media (prefers-reduced-motion:reduce){.scrub{height:auto}}
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"></script>
<script>
(() => {
  const isMobile = matchMedia('(max-width: 768px)').matches;
  const cfg = isMobile ? {dir:'frames/mobile', count:100} : {dir:'frames/desktop', count:180};
  const src = i => `${cfg.dir}/f_${String(i+1).padStart(4,'0')}.webp`;
  const canvas = document.getElementById('scrub-canvas');
  const ctx = canvas.getContext('2d');
  const imgs = new Array(cfg.count); const state = {f:0};
  const load = i => { if (imgs[i]) return imgs[i]; const im = new Image(); im.decoding='async'; im.src = src(i); imgs[i]=im; return im; };
  function size(){ const dpr=Math.min(devicePixelRatio,2); canvas.width=innerWidth*dpr; canvas.height=innerHeight*dpr; draw(); }
  function draw(){ const im = imgs[Math.round(state.f)]; if(!im||!im.complete) return;
    const cw=canvas.width, ch=canvas.height, r=Math.max(cw/im.naturalWidth, ch/im.naturalHeight);
    const w=im.naturalWidth*r, h=im.naturalHeight*r; ctx.drawImage(im,(cw-w)/2,(ch-h)/2,w,h); }
  // priorytet: pierwsza klatka, potem co 4., potem reszta
  load(0).onload = size;
  for (let i=0;i<cfg.count;i+=4) load(i);
  requestIdleCallback ? requestIdleCallback(()=>{for(let i=0;i<cfg.count;i++) load(i);}) : setTimeout(()=>{for(let i=0;i<cfg.count;i++) load(i);},300);
  gsap.registerPlugin(ScrollTrigger);
  gsap.to(state,{f:cfg.count-1, ease:'none', snap:'f',
    scrollTrigger:{trigger:'#scrub', start:'top top', end:'bottom bottom', scrub:0.5,
      onUpdate:self=>{ document.querySelectorAll('.scrub__copy').forEach(el=>{
        el.classList.toggle('is-on', self.progress>=+el.dataset.from && self.progress<=+el.dataset.to); }); }},
    onUpdate:draw});
  addEventListener('resize', size);
})();
</script>
```

Zasady:
- Wysokość sekcji 300–500vh (dłuższy scroll = wolniejsza animacja).
- Preload: pierwsza klatka jako `<link rel="preload">` i poster; reszta progresywnie.
- Fallback: `prefers-reduced-motion` i błąd ładowania → statyczny obraz ostatniej klatki.
- Teksty jako prawdziwy HTML (SEO), nie wypalone w wideo.
- Nie używaj Lenis/smooth-scroll na mobile, jeśli powoduje lag.

## 4. Strona (`scroll page`)

Struktura: hero scroll-scrub → 3 karty korzyści → galeria / oferta → opinie (tylko prawdziwe) → CTA (WhatsApp `https://wa.me/<numer>` + formularz) → stopka. Języki PL/ES/EN przełączane bez przeładowania. Typografia premium (np. serif do nagłówków + czysty sans), dużo powietrza, kolory z marki klienta.
Demo dla prospekta: oparte na jego realnych zdjęciach, bez marki Imperador AI.

## 5. Next.js (`scroll next`)

Komponent `ScrollScrub` ('use client'), propsy: `framesDesktop`, `framesMobile`, `count`, `steps[]`. GSAP przez `useGSAP`/`useLayoutEffect` z cleanupem `ScrollTrigger.kill()`. Klatki w `/public/scroll/<projekt>/` albo na CDN z długim cache.

## 6. Wdrożenie (`scroll deploy`)

- Nginx: `location ~* \.(webp|avif|mp4)$ { expires 1y; add_header Cache-Control "public, immutable"; }`, gzip/brotli dla JS/CSS.
- Wersjonuj katalog klatek (`/scroll/v2/`) zamiast czyścić cache.
- Cel Lighthouse mobile: LCP < 2,5 s (pierwsza klatka lekka), CLS 0.
- Test: iPhone Safari, Android Chrome, desktop; szybki i wolny scroll, scroll w górę.

## 7. Diagnostyka

- Szarpie → za dużo klatek/za duże pliki; obniż fps lub rozdzielczość mobile.
- Biel/miganie → rysujesz niezaladowaną klatkę; zostaw ostatnią narysowaną.
- iOS skacze wysokość → użyj `100svh`.
- Tekst nieczytelny → gradient pod tekstem zamiast ciężkiego cienia.
- Animacja za szybka → zwiększ wysokość sekcji, nie zmieniaj klatek.