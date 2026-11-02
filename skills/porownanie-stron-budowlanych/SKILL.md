---
name: porownanie-stron-budowlanych
description: Porównuje stronę firmy remontowo-budowlanej ze stronami konkurencji i mówi, czego brakuje (treść, zaufanie, konwersja, SEO, UX, wydajność).
---

# Porównanie strony firmy budowlanej z konkurencją

Cel: ocenić naszą stronę na tle 5-8 stron konkurencyjnych firm remontowo-budowlanych i podać konkretną, uporządkowaną listę braków z priorytetami. Odpowiadaj po polsku, konkretnie, bez lania wody.

## Wejście (zapytaj tylko o to, czego nie da się ustalić)
- Nasza strona: adres lokalny (np. http://localhost:PORT) albo folder projektu. Jeśli folder jest dostępny, przeczytaj też kod (index.html, style, skrypty).
- Miasto i region (np. Przemyśl, Żurawica) oraz usługi (remonty, gładzie, płyta g-k, poddasza, łazienki, drzwi i podłogi).
- Lista konkurentów: jeśli użytkownik jej nie poda, znajdź ją sam przez WebSearch (zapytania: remonty [miasto], wykończenia wnętrz [miasto], remont łazienki [miasto], oraz 2-3 liderów z większych miast jako wzór). Weź 5-8 stron: 3-4 lokalne i 2-4 wzorcowe.

## Krok 1. Dane o naszej stronie
Otwórz stronę (przeglądarka/Playwright/Chrome, jeśli dostępne) w widoku telefonu 390 px i desktop 1440 px. Zapisz: strukturę sekcji, H1, CTA (telefon, formularz, WhatsApp), zdjęcia, opinie, ceny, FAQ, mapę/obszar działania, stopkę z danymi firmy (NIP, adres), czas ładowania, wagę obrazów.

## Krok 2. Dane o konkurencji
Dla każdej strony (WebFetch lub przeglądarka) zapisz te same pola. Nie kopiuj tekstów ani zdjęć, tylko opisuj, co strona ma. Jeśli strona się nie otwiera, pomiń ją i zaznacz to; nie obchodź blokad.

## Krok 3. Macierz porównawcza
Tabela: wiersze = elementy, kolumny = nasza strona + konkurenci, wartości = tak/nie/częściowo.

Zaufanie:
- Galeria realizacji (liczba zdjęć, przed/po, podpisy z miejscem i zakresem)
- Opinie ze źródłem (Google, Fixly, Oferteo, Facebook) i liczbą ocen
- Lata doświadczenia, liczba realizacji, certyfikaty, gwarancja
- Dane firmy: nazwa, NIP, adres, godziny pracy, zdjęcie zespołu
- Umowa na piśmie, kosztorys przed pracami

Oferta:
- Opis usług na osobnych podstronach lub sekcjach
- Widoczne ceny lub widełki, proces wyceny
- Etapy współpracy, czas realizacji
- FAQ (ceny, terminy, materiały, gwarancja)

Konwersja:
- Telefon klikalny na górze i w stopce, przycisk "zadzwoń" przyklejony na telefonie
- Krótki formularz wyceny, WhatsApp/Messenger, możliwość wysłania zdjęć i wymiarów
- CTA w kilku miejscach, obietnica odpowiedzi w X godzin
- Obszar działania i mapa

SEO lokalne:
- Title i meta description z miastem i usługą, jeden H1, sensowne H2
- Osobne sekcje/strony pod frazy: remont łazienki [miasto], gładzie [miasto], zabudowa g-k [miasto]
- Dane strukturalne (LocalBusiness, Review, FAQ), alt-y, sitemap, robots
- Wizytówka Google (zgodność nazwy, adresu, telefonu), link do opinii

UX i wygląd:
- Hierarchia, typografia, kolory, spójność, jakość zdjęć, rytm sekcji
- Czy każda sekcja ma obraz lub ruch, czy jest tylko tekst
- Czytelność na telefonie, wielkość przycisków, kontrast, alt, focus

Technika:
- Czas ładowania, rozmiar obrazów (WebP/AVIF), lazy loading, Lighthouse jeśli dostępny
- HTTPS, favicon, og:image, błędy w konsoli, puste/niezaładowane sekcje
- Cookie/RODO, polityka prywatności

## Krok 4. Raport
1. Werdykt w 3 zdaniach: gdzie jesteśmy na tle rynku.
2. Co mamy lepiej (tylko prawdziwe przewagi).
3. Czego brakuje, z priorytetem: P1 (od razu), P2 (w tym tygodniu), P3 (później). Każdy punkt: co brakuje, kto z konkurencji to ma, dlaczego to ważne, jak to zrobić (jedno zdanie).
4. Tabela porównawcza (skrócona).
5. Plan 3 kroków wdrożenia z szacunkiem czasu.

## Zasady
- Opieraj się na tym, co faktycznie zobaczyłeś; czego nie da się sprawdzić, oznacz "nie sprawdzono".
- Nie wymyślaj opinii, liczb ani cen, nie kopiuj cudzych treści.
- Brakujące dane firmy (telefon, NIP, ceny) oznacz jako do potwierdzenia z klientem.
- Na koniec zaproponuj kolejny krok (galeria realizacji, formularz wyceny, przeprojektowanie sekcji) i zapytaj, od czego zacząć.
