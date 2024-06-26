#import "@preview/tablex:0.0.6": tablex, colspanx, rowspanx, vlinex

#set document(
    title: "Obliczenia Naukowe - Lista 2",
    author: "Dawid Walczak"
)
#set page(
    header: [
        _Dawid Walczak - Obliczenia naukowe_
    ]
)
#set text(
    size: 12pt
)
#set par(
    justify: true
)
#set heading(
    numbering: "1.1.1."
)

#set text(
    lang: "pl"
)

#align(center, text(size: 20pt)[
    *Lista nr 2* 
])

#show link: underline

= Zadanie 1
== Opis problemu 
Tutaj wracam się do zadania z poprzedniej listy polegającego na obliczeniu iloczynu skalarnego różnymi algorytmami. Tym razem wektor $x$ zostaje bardzo nieznacznie zaburzony.
$ tilde(x) = [x_1, x_2, x_3, x_4 + delta_1, x_5 + delta_2] $
$ "gdzie" delta_1 = -9 dot 10^(-10) " i " delta_2 = -7 dot 10^(-10) $
W tabeli umieściłem też poprzednie wyniki. Dla przypomnienia dokładny wynik działania $x dot y$ wynosił $-1.00657107 dot 10^(-11)$.

== Wyniki
#figure(caption: "Wyniki w precyzji Float64", kind: table, tablex(
    columns: (auto, auto, auto, auto, auto),
    colspanx(5)[#align(center, [*Float64*])],
    rowspanx(2)[#align(center, [*Kolejność*])], colspanx(2)[#align(center, [*Z zaburzeniem*])], colspanx(2)[#align(center, [*Bez zaburzenia*])], 
    [*Wynik*], [*Błąd względny*], [*Wynik*], [*Błąd względny*],
    [Do przodu], $-0.004296$, $4.2683 dot 10^(8)$, $1.0251881 dot 10^(-10)$, $11.185$,
    [W tył], $-0.004296$, $4.2683 dot 10^(8)$, $-1.5643309 dot 10^(-10)$, $14.541$,
    [Od max do min], $-0.004296$, $4.2683 dot 10^(8)$, $0.0$, $1.0$,
    [Od min do max], $-0.004296$, $4.2683 dot 10^(8)$, $0.0$, $1.0$
))

#figure(caption: "Wyniki w precyzji Float32", kind: table, tablex(
    columns: (auto, auto, auto, auto, auto),
    colspanx(5)[#align(center, [*Float32*])],
    rowspanx(2)[#align(center, [*Kolejność*])], colspanx(2)[#align(center, [*Z zaburzeniem*])], colspanx(2)[#align(center, [*Bez zaburzenia*])], 
    [*Wynik*], [*Błąd względny*], [*Wynik*], [*Błąd względny*],
    [Do przodu], $-0.4999$, $4.9668 dot 10^10$, $-0.4999443$, $4.9668 dot 10^10$,
    [W tył], $-0.4543$, $4.5138 dot 10^10$, $-0.4543457$, $4.5138 dot 10^10$,
    [Od max do min], $-0.5$, $4.9674 dot 10^10$, $-0.5$, $4.9674 dot 10^10$,
    [Od min do max], $-0.5$, $4.9674 dot 10^10$, $-0.5$,
    $4.9674 dot 10^10$,
))

== Wnioski 
Niezależnie od algorytmu, którym wyliczaliśmy wartość wyrażenia, te niewielkie zaburzenia przeniosły się na ogromny błąd względny wyniku. To eksperymentalnie potwierdza tezę przedstawioną na wykładzie, że liczenie iloczynu skalarnego jest zadaniem źle uwarunkowanym, gdy ma wartość bliską zeru, tj. wektory są prawie prostopadłe. 

= Zadanie 2 
== Opis problemu
To zadanie polega na przetestowaniu, jak programy do wizualizacji radzą sobie z narysowaniem funkcji $f(x) = e^x ln(1 + e^(-x))$ i spojrzeniu co się dzieje w granicy tej funkcji.
- Jako pierwszego programu użyłem #link("https://www.wolframalpha.com/input?i=plot+e%5Ex+*+ln%281+%2B+e%5E%28-x%29%29+from+-10+to+50")[Wolfram Alpha], któremu przekazałem polecenie `plot e^x * ln(1 + e^(-x)) from -10 to 50`.
- Drugą wizualizacje wykonałem w internetowym kalkulatorze graficznym #link("https://www.desmos.com/")[Desmos].
- Trzecią wizualizację przeprowadziłem w języku _Julia_ poprzez policzenie i narysowanie wartości funkcji w zakresie $[-10,50]$. 

== Wyniki
#figure(caption: [Wykres $f(x)$ narysowany przy pomocy Wolfram Alpha], image("/wolfram.png", height: 25%))

#figure(caption: [Wykres $f(x)$ narysowany przy pomocy Desmos], image("/desmos.png", height: 25%))

#figure(caption: [Wykres $f(x)$ narysowany przy pomocy języka _Julia_], image("/e.svg", height: 25%))

== Wnioski 
Żaden z wypróbowanych programów nie poradził sobie z narysowaniem tej funkcji. Granica w nieskończoności wynosi $1$, a jednak według komputera funkcja osiąga wartość $0$ dla każdego $x$ większego od 38. 
$ lim_(x->infinity) e^x ln(1 + e^(-x)) = lim_(x->infinity) ln(1 + e^(-x))/(e^(-x)) =^"d'H" lim_(x->infinity) -1/(e^x + 1) dot -1/e^(-x) = lim_(x->infinity) 1/(1 + e^(-x)) = 1 $
W celu wyjaśnienia tego zjawiska przeprowadziłem analizę błędu wyliczania wartości tej funkcji. Dla uproszczenia założyłem, że jedynym działaniem, które wprowadziło swój błąd było dodawanie $1 + e^(-x)$ i ten błąd wynosił $delta$.
$ (|e^x ln((1+e^(-x))(1 + delta)) - e^x ln(1+e^(-x))|) / (|e^x ln(1+e^(-x))|) = 
    (|ln(1+e^(-x)) + ln(1 + delta) - ln(1+e^(-x))|) / (|ln(1+e^(-x))|) = \ 
    = |1/(ln(1+e^(-x)))| |ln(1+delta)| <= |1/(ln(1+e^(-x)))| epsilon approx e^x epsilon $
Stąd wyliczanie tej funkcji staje się niebezpiecznie nawet dla względnie niedużych $x$. W ogólności należy uważać na mnożenie ze sobą liczby bardzo dużej z liczbą bardzo małą.

= Zadanie 3
== Opis problemu
W tym zadaniu poddane testowi jest rozwiązywanie układu równań zadanego macierzą. Dla każdej macierzy generowany jest wektor prawych stron poprzez wymnożenie $A dot x$, gdzie $x = [1, 1, dots 1]$ będzie dokładnym rozwiązaniem układu równań. Następnie wyliczane są błędy wzgledne wyników dla dwóch algorytmów - eliminacji Gaussa wywołanego poleceniem `A \ b` oraz obliczania wyrażenia $A^(-1)b$. Eksperymenty zostały przeprowadzone na macierzach Hilberta o rosnących rozmiarach oraz losowo wygenerowanych macierzach z danym współczynnikiem uwarunkowania $c$. Wyniki losowe zostały uśrednione dla próbki $1000$.
#pagebreak()
== Wyniki
#figure(caption: [Wyniki dla macierzy Hilberta w formie wykresu], image("./hilb.svg", width: 80%))

#figure(caption: [Wyniki dla macierzy Hilberta w formie tabeli], kind: table, tablex(
    columns: (auto, auto, auto, auto, auto),
    $n$, `rank(A)`, `cond(A)`, [Błąd `A\b`], [Błąd `inv(A)*b`], 
    $2$, $2$, $19.2815$, $5.66105 dot 10^(-16)$, $1.12402 dot 10^(-15)$,
    $3$, $3$, $524.057$, $8.35106 dot 10^(-15)$, $9.82553 dot 10^(-15)$,
    $4$, $4$, $15513.7$, $4.22673 dot 10^(-13)$, $3.96 dot 10^(-13)$,
    $5$, $5$, $476607.0$, $1.25683 dot 10^(-12)$, $8.12817 dot 10^(-12)$,
    $6$, $6$, $1.49511 dot 10^(7)$, $1.54351 dot 10^(-10)$, $1.04238 dot 10^(-10)$,
    $7$, $7$, $4.75367 dot 10^(8)$, $6.5208 dot 10^(-9)$, $4.32992 dot 10^(-9)$,
    $8$, $8$, $1.52576 dot 10^(10)$, $3.60105 dot 10^(-7)$, $4.02368 dot 10^(-7)$,
    $9$, $9$, $4.93153 dot 10^(11)$, $1.3217 dot 10^(-5)$, $1.46268 dot 10^(-5)$,
    $10$, $10$, $1.6025 dot 10^(13)$, $0.000419417$, $0.000407149$,
    $11$, $10$, $5.22478 dot 10^(14)$, $0.0100491$, $0.010646$,
    $12$, $11$, $1.64259 dot 10^(16)$, $0.550211$, $0.669789$,
    $13$, $11$, $4.49367 dot 10^(18)$, $70.1556$, $82.6668$,
    $14$, $11$, $3.21984 dot 10^(17)$, $9.64964$, $10.0947$,
    $15$, $12$, $3.36601 dot 10^(17)$, $692.43$, $715.741$,
    $16$, $12$, $2.24994 dot 10^(18)$, $10.4147$, $8.44214$,
    $17$, $12$, $6.26205 dot 10^(17)$, $18.6758$, $17.158$,
    $18$, $12$, $3.26663 dot 10^(18)$, $5.40548$, $3.74241$,
    $19$, $13$, $3.4623 dot 10^(18)$, $15.0739$, $16.8477$,
    $20$, $13$, $6.80697 dot 10^(18)$, $28.7927$, $30.7512$,
))

#figure(caption: [Wyniki dla macierzy $R_5$], kind: table, tablex(
    columns: (auto, auto, auto, auto, auto),
    colspanx(5)[#align(center, $n = 5$)],
    $c$, `rank(A)`, `cond(A)`, [Błąd `A\b`], [Błąd `inv(A)*b`], 
    $1$, $5$, $1.0$, $1.72531 dot 10^(-16)$, $1.69426 dot 10^(-16)$,
    $10$, $5$, $10.0$, $2.57554 dot 10^(-16)$, $2.60206 dot 10^(-16)$,
    $10^3$, $5$, $1000.0$, $1.78834 dot 10^(-14)$, $1.86758 dot 10^(-14)$,
    $10^(7)$, $5$, $1.0 dot 10^(7)$, $1.82978 dot 10^(-10)$, $1.94604 dot 10^(-10)$,
    $10^(12)$, $5$, $9.99999 dot 10^(11)$, $1.7274 dot 10^(-5)$, $1.81588 dot 10^(-5)$,
    $10^(16)$, $4$, $7.21813 dot 10^(16)$, $0.205524$, $0.214423$,
))

#figure(caption: [Wyniki dla macierzy $R_10$], kind: table, tablex(
    columns: (auto, auto, auto, auto, auto),
    colspanx(5)[#align(center, $n = 10$)],
    $c$, `rank(A)`, `cond(A)`, [Błąd `A\b`], [Błąd `inv(A)*b`], 
    $1$, $10$, $1.0$, $2.76712 dot 10^(-16)$, $2.5242 dot 10^(-16)$,
    $10$, $10$, $10.0$, $3.46691 dot 10^(-16)$, $3.35893 dot 10^(-16)$,
    $10^3$, $10$, $1000.0$, $1.89975 dot 10^(-14)$, $1.94355 dot 10^(-14)$,
    $10^(7)$, $10$, $1.0 dot 10^(7)$, $1.78784 dot 10^(-10)$, $1.86803 dot 10^(-10)$,
    $10^(12)$, $10$, $1.0 dot 10^(12)$, $1.82771 dot 10^(-5)$, $1.88361 dot 10^(-5)$,
    $10^(16)$, $9$, $2.34787 dot 10^(16)$, $0.197388$, $0.200439$,
))

#figure(caption: [Wyniki dla macierzy $R_20$], kind: table, tablex(
    columns: (auto, auto, auto, auto, auto),
    colspanx(5)[#align(center, $n = 20$)],
    $c$, `rank(A)`, `cond(A)`, [Błąd `A\b`], [Błąd `inv(A)*b`], 
    $1$, $20$, $1.0$, $4.81451 dot 10^(-16)$, $4.05122 dot 10^(-16)$,
    $10$, $20$, $10.0$, $5.10347 dot 10^(-16)$, $4.86107 dot 10^(-16)$,
    $10^3$, $20$, $1000.0$, $1.90056 dot 10^(-14)$, $1.93965 dot 10^(-14)$,
    $10^(7)$, $20$, $1.0 dot 10^(7)$, $1.91321 dot 10^(-10)$, $1.95645 dot 10^(-10)$,
    $10^(12)$, $20$, $1.0 dot 10^(12)$, $1.88181 dot 10^(-5)$, $1.93414 dot 10^(-5)$,
    $10^(16)$, $19$, $4.86352 dot 10^(16)$, $0.212953$, $0.217771$,
))

== Wnioski
Nawet dla niedużych macierzy nie da się rozwiązać układu równań z pewną dokładnością, jeżeli są złośliwe. To zadanie jest dla takich macierzy źle uwarunkowane, na co wskazuje fakt, że błędy są takie same niezależnie od użytego algorytmu. Wyniki wskazują, że współczynnik uwarunkowania może osiągnąć ogromne wartości. Macierze Hilberta są w tym przypadku szczególnie złośliwe, , osiągając współczynnik uwarunkowania rzędu $10^16$ już dla niewielkiego $n = 12$. Można też zauważyć na losowo generowanych macierzach, że błędy w istocie zależały głównie od uwarunkowania, a nie miał na nie wpływ rozmiar macierzy.

#pagebreak()
= Zadanie 4
== Opis problemu 
W tym zadaniu badam wielomian Wilkinsona wyznaczony wzorem $p(x) = Pi^20_(i=1)(x-i)$. Najpierw używam jego naturalnej $P(x)$ i przy użyciu pakietu `Polynomials` wyliczam jego pierwiastki $z_k$. Potem porównuję ze sobą wartości $|P(z_k)|$, $|p(z_k)|$ i błąd $|z_k - k|$. W drugiej części zadania dodatkowo zaburzyłem współczynnik $a_19$ o $-2^(-23)$.

== Wyniki
#figure(caption: [Wyniki dla niezaburzonego wielomianu], kind: table, tablex(
    columns: (auto, auto, auto, auto),
    [$z_k$], [$|P(z_k)|$], [$|p(z_k)|$], [$|z_k - k|$], 
    $0.9999999999997$, $35696.5$, $36626.4$, $3.01092 dot 10^(-13)$,
    $2.0000000000283$, $176253.0$, $181304.0$, $2.83182 dot 10^(-11)$,
    $2.9999999995921$, $279158.0$, $290172.0$, $4.07903 dot 10^(-10)$,
    $3.9999999837375$, $3.02711 dot 10^(6)$, $2.04154 dot 10^(6)$, $1.62625 dot 10^(-8)$,
    $5.0000006657698$, $2.29175 dot 10^(7)$, $2.08946 dot 10^(7)$, $6.6577 dot 10^(-7)$,
    $5.9999892458248$, $1.29024 dot 10^(8)$, $1.12505 dot 10^(8)$, $1.07542 dot 10^(-5)$,
    $7.000102002793$, $4.80511 dot 10^(8)$, $4.57291 dot 10^(8)$, $0.000102003$,
    $7.9993558296078$, $1.63795 dot 10^(9)$, $1.55565 dot 10^(9)$, $0.00064417$,
    $9.0029152943621$, $4.87707 dot 10^(9)$, $4.68782 dot 10^(9)$, $0.00291529$,
    $9.9904130424817$, $1.36386 dot 10^(10)$, $1.26346 dot 10^(10)$, $0.00958696$,
    $11.025022932909$, $3.58563 dot 10^(10)$, $3.30013 dot 10^(10)$, $0.0250229$,
    $11.953283253847$, $7.53333 dot 10^(10)$, $7.38853 dot 10^(10)$, $0.0467167$,
    $13.074314032447$, $1.9606 dot 10^(11)$, $1.84762 dot 10^(11)$, $0.074314$,
    $13.914755591802$, $3.57513 dot 10^(11)$, $3.55143 dot 10^(11)$, $0.0852444$,
    $15.075493799699$, $8.21627 dot 10^(11)$, $8.4232 dot 10^(11)$, $0.0754938$,
    $15.946286716608$, $1.5515 dot 10^(12)$, $1.57073 dot 10^(12)$, $0.0537133$,
    $17.025427146237$, $3.69474 dot 10^(12)$, $3.31698 dot 10^(12)$, $0.0254271$,
    $17.990921352716$, $7.65011 dot 10^(12)$, $6.34485 dot 10^(12)$, $0.00907865$,
    $19.001909818299$, $1.14353 dot 10^(13)$, $1.22857 dot 10^(13)$, $0.00190982$,
    $19.999809291237$, $2.79241 dot 10^(13)$, $2.31831 dot 10^(13)$, $0.000190709$,
))

#figure(caption: [Wyniki dla zaburzonego wielomianu], kind: table, tablex(
    columns: (auto, auto, auto, auto),
    [$tilde(z_k)$], [$|tilde(P)(tilde(z_k))|$], [$|p(tilde(z_k))|$], [$|tilde(z_k) - k|$], 
    $0.9999999999998$, $20259.9$, $19987.9$, $1.64313 dot 10^(-13)$,
    $2.00000000006$, $346541.0$, $352369.0$, $5.50373 dot 10^(-11)$,
    $2.999999996604$, $2.25806 dot 10^(6)$, $2.41624 dot 10^(6)$, $3.39658 dot 10^(-9)$,
    $4.0000000897244$, $1.05426 dot 10^(7)$, $1.12637 dot 10^(7)$, $8.97244 dot 10^(-8)$,
    $4.9999985738879$, $3.75783 dot 10^(7)$, $4.47574 dot 10^(7)$, $1.42611 dot 10^(-6)$,
    $6.000020476673$, $1.31409 dot 10^(8)$, $2.1421 dot 10^(8)$, $2.04767 dot 10^(-5)$,
    $6.9996020704224$, $3.93936 dot 10^(8)$, $1.78462 dot 10^(9)$, $0.00039793$,
    $8.0077720290994$, $1.18499 dot 10^(9)$, $1.8687 dot 10^(10)$, $0.00777203$,
    $8.9158163679326$, $2.22552 dot 10^(9)$, $1.37463 dot 10^(11)$, $0.0841836$,
    $10.0955 - 0.644933im$, $1.06779 dot 10^(10)$, $1.49007 dot 10^(12)$, $0.651959$,
    $10.0955 + 0.644933im$, $1.06779 dot 10^(10)$, $1.49007 dot 10^(12)$, $1.11092$,
    $11.7939 - 1.65248im$, $3.1402 dot 10^(10)$, $3.29628 dot 10^(13)$, $1.66528$,
    $11.7939 + 1.65248im$, $3.1402 dot 10^(10)$, $3.29628 dot 10^(13)$, $2.04582$,
    $13.9924 - 2.51882im$, $2.15767 dot 10^(11)$, $9.54602 dot 10^(14)$, $2.51884$,
    $13.9924 + 2.51882im$, $2.15767 dot 10^(11)$, $9.54602 dot 10^(14)$, $2.71288$,
    $16.7307 - 2.81262im$, $4.85011 dot 10^(11)$, $2.74211 dot 10^(16)$, $2.906$,
    $16.7307 + 2.81262im$, $4.85011 dot 10^(11)$, $2.74211 dot 10^(16)$, $2.82548$,
    $19.5024 - 1.94033im$, $4.5572 dot 10^(12)$, $4.25249 dot 10^(17)$, $2.45402$,
    $19.5024 + 1.94033im$, $4.5572 dot 10^(12)$, $4.25249 dot 10^(17)$, $2.00433$,
    $20.8469$, $8.75639 dot 10^(12)$, $1.37437 dot 10^(18)$, $0.84691$,
))

== Wnioski
Wielomian Wilkinsona okazał się wyjątkowo złośliwy przy próbie wyliczenia jego pierwiastków. W pierwszej części zadania mogłoby się wydawać, że różnice między wyliczonym pierwiastkiem a prawdziwym są niewielkie. Jednak podczas wyliczania wartości wielomianu w danym pierwiastku następuję kumulacja tego niewielkiego błędu i otrzymałem wartości znacznie oddalone od oczekiwanego $0$.
\
Już na samym początku pojawiło się względnie niewielkie zaburzenie współczynników wielomianu. $a_4 = 8037811822645051776$, a jednak gdy zostanie to zapisane w komputerze w precyzji Float64, to po odczytaniu dostanie się $tilde(a_4) = 8037811822645051392$ - te wartości różnią się o $384$.
\
W drugiej części zadania sam nieznacznie zaburzyłem jeden współczynnik, a to wystarczyło, żeby oryginalnie całkowite pierwiastki wielomiany stały się nie dosyć że zespolone, to jeszcze znacznie oddalone.
To potwierdza tezę, że zadanie wyznaczania pierwiastków tego wielomianu jest źle uwarunkowane. 

= Zadanie 5
== Opis problemu
Rozważane jest równanie rekurencyjne modelu logistycznego.
$ p_(n+1) = p_n + r p_n (1 - p_n) " z danym " p_0 " i " r $
Startując z początkowym stanem populacji $p_0 = 0.01$ i współczynnikiem wzrostu $r = 3$, wykonałem $40$ iteracji tego procesu.
- W arytmetyce Float32.
- W arytmetyce Float32, ale z wprowadzonym zaburzeniem poprzez zaokrąglenie wyniku $10$ iteracji do 3 miejsc po przecinku.
- W arytmetyce Float64.

== Wyniki 

#figure(caption: [Porównanie iteracji w formie wykresu], image("./logic.svg", width: 80%))

#figure(caption: [Wyniki iteracji], kind: table, tablex(
    columns: (auto, auto, auto, auto, auto),
    [*Iteracja*], [*W Float64*], [*W Float32* \ *z zaburzeniem*], [*W Float32*], [*Komentarz*], 
    $0$, $0.01$, $0.01$, $0.01$, [],
    $1$, $0.0397$, $0.0397$, $0.0397$, [],
    $2$, $0.15407173$, $0.15407173$, $0.15407173$, [],
    $3$, $0.545072626044$, $0.5450726$, $0.5450726$, rowspanx(2)[Dla Float32 zostają ucięte ostatnie cyfry],
    $4$, $1.28897800119$, $1.2889781$, $1.2889781$,
    $dots$,$dots$,$dots$,$dots$, [],
    $10$, $0.72291430118$, $0.722$, $0.7229306$, rowspanx(2)[Zostaje wprowadzone zaburzenie],
    $11$, $1.32384194417$, $1.3241479$, $1.3238364$,
    $12$, $0.0376952972547$, $0.036488414$, $0.037716985$, [],
    $dots$,$dots$,$dots$,$dots$, [],
    $17$, $0.788101190235$, $0.9010855$, $0.7860428$, rowspanx(3)[Zaburzony i niezaburzony zaczynają się widocznie różnić],
    $18$, $1.28909430279$, $1.1684768$, $1.2905813$,
    $19$, $0.171084846702$, $0.577893$, $0.16552472$,
    $20$, $0.596529312495$, $1.3096911$, $0.5799036$, rowspanx(2)[Zaburzony znajduje się nad 1, a reszta poniżej],
    $21$, $1.31857558798$, $0.09289217$, $1.3107498$,
    $22$, $0.0583776082594$, $0.34568182$, $0.088804245$, rowspanx(2)[Float64 i Float32 zaczynają się widocznie różnić],
    $23$, $0.223286597599$, $1.0242395$, $0.33155844$,
    $dots$,$dots$,$dots$,$dots$, [],
    $30$, $0.374146489639$, $1.3191822$, $0.752921$, rowspanx(3)[Nie widać już żadnego powiązania między iteracjami],
    $31$, $1.07662917143$, $0.05600393$, $1.3110139$,
    $32$, $0.8291255674$, $0.21460637$, $0.0877831$,
    $dots$,$dots$,$dots$,$dots$, [],
    $38$, $1.33260564696$, $1.2292118$, $0.81736827$, [],
    $39$, $0.00290915690285$, $0.3839622$, $1.2652004$, [],
    $40$, $0.0116112380297$, $1.093568$, $0.25860548$, [],
))

== Wnioski 
Już po paru iteracjach od wprowadzenia zaburzenia można zauważyć znaczne różnice pomiędzy ciągiem zaburzonym i niezaburzonym. Te różnice powiększały wraz z kolejnymi iteracjami.
Jeżeli $p_n$ potrzebuje $k$ cyfr do dokładnego zapisania, to wyrażenie $p_n (1-p_n)$ potrzebuję już $2k$ cyfr. Ucinanie następuje bardzo szybko w precyzji Float32, a trochę później dla Float64 i wprowadza błąd obliczania.
Wyliczanie funkcji dla argumentu obarczonego błędem powoduje nałożenie jeszcze większego błędu, co spowodowało że wyniki esperymentów rozbiegły się od siebie. 
Skoro zjawisko utraty dokładności występuje też w Float64, to w tej sytuacji nie stanowi ono lepszego przybliżenia pradziwej wartości niż Float32.
Proces ten można nazwać numerycznie niestabilnym.

= Zadanie 6
== Opis problemu
Rozważane jest równanie rekurencyjne.
$ x_(n+1) = x_n^2 + c " z danym " x_0 " i " c $
Zbadałem zachowanie tego równania dla danych wartości $x_0$ i $c$ dla $40$ pierwszych wyrazów, a następnie zwizualizowałem dla nich iterację graficzną.

== Wyniki
#figure(caption: [Iteracja graficzna $c = -2 space x_0 = 1$], image("./plots/-2_1.svg", height: 28%))
#figure(caption: [Iteracja graficzna $c = -2 space x_0 = 2$], image("./plots/-2.0_2.0.svg", height: 28%))
#figure(caption: [Iteracja graficzna $c = -2 space x_0 = 1.99999999999999$], image("./plots/-2.0_1.99999999999999.svg", height: 28%))
#figure(caption: [Iteracja graficzna $c = -1 space x_0 = -1$], image("./plots/-1.0_-1.0.svg", height: 28%))
#figure(caption: [Iteracja graficzna $c = -1 space x_0 = 0.25$], image("./plots/-1.0_0.25.svg", height: 28%))
#figure(caption: [Iteracja graficzna $c = -1 space x_0 = 0.75$], image("./plots/-1.0_0.75.svg", height: 28%))
#figure(caption: [Iteracja graficzna $c = -1 space x_0 = 1$], image("./plots/-1.0_1.0.svg", height: 28%))

== Wnioski
Z wykresu iteracji graficznej można odczytać punkty stałe danego równania rekurencyjnego. Dla $c = -2$ są to dokładnie $-1$ i $2$, w których kończymy na Rysunku 6 i 7 i nie możemy już ich opuścić. Natomiast bardzo niewielkie odchylenie się od $2$ wywołało całkowity chaos, w którym nie udało się do niczego zbiec. Proces z $x_0 = 1.99999999999999$ stał się niestabilny. Nastąpiła duża czułość na warunki początkowe.
Dla $c = -1$ punkty stałe znajdują się w $(1 plus.minus sqrt(5))/2$, jednak dla danych $x_0$ ciąg nie zbiegał do nich, ale do cyklu $0, -1, 0, -1, dots$. Nastąpiło to dla każdego testowanego $x_0$, co jest przejawem zachowania stabilnego.
