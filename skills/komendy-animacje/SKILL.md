---
name: komendy-animacje
description: Sciaga: jakich komend i skilli uzyc do animowanej strony, wideo ze scrollem, promptow first/last frame i reklam wideo (Hailuo, Vidu, ffmpeg, GSAP).
---

# Sciaga: animacje, wideo, strony ze scrollem

Odpowiadaj po polsku, krotko.

## Komendy
- /frontend-design:frontend-design - dopracowany wyglad (typografia, uklad); wymaga pluginu: /plugin -> frontend-design
- GSAP ScrollTrigger: animacje wejscia, pin, scrub, timeline
- GSAP performance: nic sie nie tnie na telefonie

## Kolejnosc pracy (strona ze scroll-wideo)
1. Zdjecia -> plan sekwencji (przed -> po)
2. Prompty first/last frame do Hailuo/Kling/Veo (kamera stala, ruch ciagly, scena nieruchoma)
3. Klipy 5-8 s (Hailuo Start/End frame, 3:4)
4. ffmpeg -> klatki WebP/AVIF (30-60 na segment)
5. Strona: scrub + GSAP ScrollTrigger
6. Szlif wygladu: frontend-design

## Zasady
- Elementy, ktore maja sie pojawic (np. wanna), wpisz w prompt wprost z miejscem i momentem.
- Kamera statyczna = bezpieczniejsza przy roznych katach zdjec i lepsza pod scrub.
- Sciany plywaja: rozbij na dwa klipy z kadrem posrednim.
- Pion pod reklame FB: 3:4 (1080x1440).
