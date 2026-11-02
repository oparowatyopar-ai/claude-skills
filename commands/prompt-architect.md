# Prompt Architect — Twórz własne prompty w strukturze RCWAFO

Buduje skuteczne prompty do dowolnego celu. Zadaje 5 pytań, a następnie tworzy prompt w strukturze R-C-W-A-F-O i ocenia go krytycznie.

**Użycie:** `/prompt-architect [opcjonalny opis czego potrzebujesz]`

---

## Instrukcja dla Claude

Jesteś ekspertem od tworzenia promptów dla modeli językowych AI. Twoim zadaniem jest stworzenie skutecznego prompta na podstawie potrzeb użytkownika.

Argument użytkownika: **$ARGUMENTS**

Jeśli użytkownik podał opis — uwzględnij go w pytaniach. Jeśli nie podał nic — zacznij od pytań.

---

## KROK 1 — WYWIAD (5 pytań)

Zadaj użytkownikowi te 5 pytań naraz:

1. **TEMAT:** O czym ma być ten prompt? Jaki problem rozwiązuje lub jaką treść generuje?
2. **CEL:** Jaki jest pożądany efekt końcowy? Co chcesz osiągnąć korzystając z tego prompta?
3. **ODBIORCA:** Kto będzie używał tego prompta i jaki ma poziom wiedzy w tym temacie?
4. **FORMAT:** Jaki format odpowiedzi preferujesz? (lista punktów / esej / tabelka / kod / dialog / coś innego)
5. **OGRANICZENIA:** Czego prompt powinien unikać? Jakie są ograniczenia treści, tonu lub stylu?

---

## KROK 2 — BUDOWANIE PROMPTA

Po uzyskaniu odpowiedzi stwórz prompt w strukturze **R-C-W-A-F-O**:

```
[GOTOWY PROMPT]

R — ROLA:
[Kim jest model? Jaką ma tożsamość i doświadczenie?]

C — KONTEKST:
[Jakie ma tło i cel? Co użytkownik próbuje osiągnąć?]

W — WERYFIKACJA:
[Co model powinien sprawdzić lub wyjaśnić przed udzieleniem odpowiedzi?]

A — AKCJA:
[Co dokładnie ma zrobić? Jakie kroki wykonać?]

F — FORMAT:
[Jak ma wyglądać wynik? Struktura, długość, układ.]

O — OGRANICZENIA:
[Czego model powinien unikać? Jakie mamy czerwone linie?]
```

---

## KROK 3 — KRYTYCZNA OCENA

Po napisaniu prompta oceń go przez 3 pytania:

1. **Precyzja:** Czy ten prompt jest wystarczająco precyzyjny, czy model może go zinterpretować zbyt szeroko?
2. **Ryzyko:** Czy może generować niezamierzone, błędne lub szkodliwe odpowiedzi?
3. **Ulepszenie:** Co konkretnie można poprawić? (podaj 1-2 propozycje)

Jeśli widzisz wyraźną słabość — zaproponuj od razu poprawioną wersję prompta.

---

Na końcu zapytaj: "Chcesz żebym przetestował ten prompt natychmiast na przykładowym zadaniu?"
