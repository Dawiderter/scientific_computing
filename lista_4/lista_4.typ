#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

#set document(
    title: "Obliczenia Naukowe - Lista 4",
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
#show par: set block(spacing: 0.65em)
#set par(
    justify: true,
    first-line-indent: 1em
)
#set heading(
    numbering: "1.1.1."
)

#set text(
    lang: "pl"
)

#align(center, text(size: 20pt)[
    *Lista nr 4* 
])

#show link: underline

= Obliczanie ilorazów różnicowych

== Zadanie interpolacji wielomianowej 
Zadanie interpolacji wielomianowej polega na znalezieniu wielomianu $p(x)$ co najwyżej $n$-tego stopnia, takiego że dla danych $n + 1$ punktów $(x_i, y_i)$ $0 <= i <= n$ zachodzi $p(x_i) = y_i$.

Jednym ze sposobów na rozwiązanie tego zadania jest znalezienie postaci $p(x)$ w bazie $1, (x - x_0), (x - x_0)(x - x_1), dots, Pi_(i = 0)^(n-1)(x - x_i)$. Nazywamy to postacią interpolacyjną Newtona, a współczynniki wielomianu nazywamy ilorazami różnicowymi i oznaczamy $c_i = f[x_0, x_1, dots, x_i]$.

== Wyznaczanie ilorazów różnicowych
Ilorazy różnicowe można wyliczyć za pomocą zależności rekurencyjnej:
$ f[x_i] = f(x_i) $
$ f[x_0, x_1, dots, x_n] = (f[x_1, x_2, dots, x_n] - f[x_0, x_1, x_(n-1)])/(x_n - x_0) $
Z tych zależności wynika, że problem wyznaczenia ilorazów różnicowych możemy rozwiązać stosując metodę programowania dynamicznego. 
$ mat(
    delim: "[",
    f[x_0];
    "",arrow.br;
    f[x_1], arrow.r, f[x_0,x_1];
    "",arrow.br,"", arrow.br;
    f[x_2], arrow.r, f[x_1,x_2], arrow.r, f[x_0, x_1,x_2];
    "",arrow.br,"",arrow.br,"", arrow.br;
    dots.v, "", dots, "", dots, "", dots.down;
    "",arrow.br,"",arrow.br,"", arrow.br,"", arrow.br;
    f[x_n], arrow.r, f[x_(n-1), x_n], arrow.r, f[x_(n-2), x_(n-1), x_n], arrow.r, dots, arrow.r, f[x_0, dots, x_n];
) $

Współczynniki wielomianu rozwiązującego problem interpolacji znajdują się po przekątnej tej macierzy. Oznaczmy elementy tej macierzy jako $b_(j,i)$ dla $0 <= j, i <= n$. Wtedy znając kolumnę $i - 1$ możemy wyliczyć elementy kolumny $i$ za pomocą wzoru:

$ b_(j,i) = (b_(j,i-1) - b_(j-1,i-1))/(x_j - x_(j - i)) "dla" 1 <= i <= j <= n $

Można też zauważyć, że w końcowym algorytmie nie musimy pamiętać całej macierzy, a jedynie wektor opisujący daną kolumnę. Do obliczenia elementu w wierszu $j$ potrzebujemy jedynie poprzednich elementów z wierszów $j$ i $j - 1$. Zatem jeżeli zaczniemy wyznaczanie danej kolumny "od tyłu", tj. od $j = n$ do $j = i$, to możemy nadpisywać element w wierszu $j$ elementem z następnej kolumny, bo nie przyda się już do kolejnych obliczeń.


#let fx = $f x$
#algorithm({
  import algorithmic: *
  Function("Ilorazy-Różnicowe", args: ($x = [x_0, dots, x_n]$, $y = [f(x_0), dots, f(x_n)]$), {
    Assign[$fx$][$y$]
    For(cond: $i "from" 1 "to" n$ ,{
        For(cond: $j "from" n "to" i$ ,{
            Assign($fx_j$, $(fx_j - fx_(j-1)) \/ (x_j - x_(j - i))$)
        })
    })
    Return($fx$)
  })
})

= Wyznaczanie wartości wielomianu interpolacyjnego 

== Uogólniony wzór Hornera
W poprzednim zadaniu udało się wyznaczyć wielomian interpolacyjny w postaci Newtona:

$ p(x) = f[x_0] + f[x_0,x_1](x-x_0) + dots + f[x_0, dots, x_n]Pi_(i = 0)^(n-1)(x - x_i) $

Ten wzór można inaczej przedstawić, wyciągając wspólne czynniki:

$ p(x) = f[x_0] + (x-x_0)(f[x_0,x_1] + (x-x_1)(f[x_0,x_1,x_2] + dots)) $

Tym samym, licząc "od środka", otrzymujemy ciąg wielomianów pośrednich $w_i (x)$ wyrażających się zależnością:

$ w_n (x) = f[x_0, dots, x_n] $
$ w_i (x) = f[x_0, dots, x_i] + (x - x_i) w_(i+1)(x) "dla" 0 <= i <= n - 1 $

Gdzie $w_0 (x) = p(x)$. Tą metodę nazywamy uogólnionym algorytmem Hornera. Pozwala na wyliczenie wartości $p(x)$ w punkcie $x$ w liniowej liczbie działań, w przeciwieństwie do metody naiwnej, która potrzebuję kwadratowej liczby działań.

#algorithm({
  import algorithmic: *
  Function("Wartość-Newton", args: ($t, x = [x_0, dots, x_n]$, $fx = [f[x_0], dots, f[x_0, dots, x_n]]$), {
    Assign[$w$][$fx_n$]
    For(cond: $i "from" n-1 "to" 0$ ,{
        Assign($w$, $fx_i + w dot (t - x_i)$)
    })
    Return($w$)
  })
})

= Zamiana postaci Newtona na postać naturalną
== Wykorzystanie wzoru Hornera

Wiemy, że wielomian pośredni uzyskany metodą Hornera $w_i (x)$ jest maksymalnie stopnia $n - i$.
Przedstawmy dwa kolejne uzyskane wielomiany w postaciach naturalnych:
$ w_(i + 1) (x) = a_0 + a_1 x + a_2 x^2 + dots + a_(n-i-1) x^(n-i-1) $
$ w_(i) (x) = b_0 + b_1 x + b_2 x^2 + dots + b_(n-i) x^(n-i) $
Z zależności rekurencyjnej $w_i (x) = f[x_0, dots, x_i] + (x - x_i) w_(i+1)(x)$ wynika że:

$ b_0 + b_1 x + dots + b_(n-i) x^(n-i) = $
$ = f[x_0, dots, x_i] + (x - x_i) (a_0 + a_1 x + dots + a_(n-i-1) x^(n-i-1)) = $
$ = f[x_0, dots, x_i] + (a_0 x + dots + a_(n-i-1) x^(n-i)) - (a_0 x_i + dots + a_(n-i-1) x_i x^(n-i-1)) = $
$ = f[x_0, dots, x_i] - a_0 x_i + (a_0 - a_1 x_i) x + dots + 
    (a_(n-i-2) - a_(n-i-1) x_i) x^(n - i - 1) + a_(n-i-1) x^(n - i) $

Z równości wielomianów wynika równość ich współczynników, więc:

$ b_0 = f[x_0, dots, x_i] - a_0 x_i, space b_(n-i) = a_(n-i-1), space b_j = a_(j-1) - a_j x_i "dla" 1 <= j <= n-i-1 $ 

== Algorytm

Znając więc współczynniki postaci naturalnej wielomianu pośredniego $w_(i+1)(x)$, możemy wyznaczyć współczynniki postaci naturalnej wielomianu $w_i (x)$. Tym samym zaczynając od $w_n (x) = f[x_0, dots, x_n]$, możemy policzyć szukane współczynniki $p(x) = w_0 (x)$.

Tak samo jak w zadaniu $1$, wystarczy tablica $n + 1$ elementów. Do obliczenia $b_j$ potrzeba jedynie $a_j$ i $a_(j-1)$, więc idąc "od tyłu", możemy nadpisywać niepotrzebne już do obliczeń wartości. Widać też, że algorytm wykonuje $O(n^2)$ działań.

#algorithm({
  import algorithmic: *
  Function("Postać-Naturalna", args: ($x = [x_0, dots, x_n]$, $fx = [f[x_0], dots, f[x_0, dots, x_n]]$), {
    Assign[$b$][$[0,dots,0]$]
    Assign[$b_0$][$fx_n$]
    For(cond: $i "from" n-1 "to" 0$ ,{
        Assign[$b_(n-i)$][$b_(n-i-1)$]
        For(cond: $j "from" n-i-1 "to" 1$ ,{
            Assign($b_j$, $b_(j-1) - b_j x_i$)
        })
        Assign($b_0$, $fx_i - b_0 x_i$)
    })
    Return($b$)
  })
})

= Interpolacja na rysunkach
== Opis
Zastosowałem pokazane algorytmy do przedstawienia interpolacji przykładowych funkcji dla równoodległych węzłów:
- $e^x$ na przedziale $[0,1]$
- $x^2 sin x$ na przedziale $[-1,1]$

#figure(
    caption: [Wielomian stopnia $5$ interpolujacy $x^2 sin x$],
    image("./plots/sinx_5.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $10$ interpolujacy $x^2 sin x$],
    image("./plots/sinx_10.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $15$ interpolujacy $x^2 sin x$],
    image("./plots/sinx_15.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $5$ interpolujacy $e^x$],
    image("./plots/ex_5.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $10$ interpolujacy $e^x$],
    image("./plots/ex_10.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $15$ interpolujacy $e^x$],
    image("./plots/ex_15.svg", width: 65%)
)

== Wnioski
Funkcje te dają sie bardzo łatwo interpolować przy pomocy równoodległych węzłów, nie ma znaczących błędów nawet dla wielomianów niskiego stopnia.

= Błędy interpolacji
== Opis
Tym razem, znowu z równoodległymi węzłami, przeprowadziłem interpolację funkcji:
- $|x|$ na przedziale $[-1,1]$
- $1/(1 + x^2)$ na przedziale $[-5,5]$
== Wyniki

#figure(
    caption: [Wielomian stopnia $5$ interpolujacy $|x|$],
    image("./plots/absx_5.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $10$ interpolujacy $|x|$],
    image("./plots/absx_10.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $15$ interpolujacy $|x|$],
    image("./plots/absx_15.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $5$ interpolujacy $1/(1 + x^2)$],
    image("./plots/1x2_5.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $10$ interpolujacy $1/(1 + x^2)$],
    image("./plots/1x2_10.svg", width: 65%)
)

#figure(
    caption: [Wielomian stopnia $15$ interpolujacy $1/(1 + x^2)$],
    image("./plots/1x2_15.svg", width: 65%)
)

== Wnioski 
Na wykresach pojawia się widoczna różnica pomiędzy wartościami funkcji i interpolującego go wielomianu. Co istotne widoczny błąd interpolacji nie maleje wraz ze zwiększaniem stopnia wielomianu, a wręcz w niektórych miejscach rośnie.

W przypadku funkcji $f(x) = |x|$, błąd może się brać z tego, że pochodna funkcji nie jest ciągła - $f$ nie jest różniczkowalna w punkcie $x = 0$. Natomiast algorytm używa gładkich wielomianów, co powoduje zniekształcenia.

Przy funkcji $f(x) = 1/(1 + x^2)$ mamy do czynienia z efektem Rungego. Błąd interpolacji możemy wyrazić wzorem:
$ f(x) - p(x) = 1/(n+1)! f^((n+1))(xi_x) Pi_(i=0)^n (x-x_i) "z pewnym" xi_x in (a,b) $
Okazuje się, że wraz z rosnącym $n$ bardzo szybką rosną wartości $n$-tej pochodnej $f$ i ten błąd rozbiega dla interpolacji wielomianem o równoodległych węzłach. W tym przypadku co można zrobić, to zastosować wielomiany Czebyszewa lub użyć innych metod interpolacji.

#figure(
    caption: [Wielomian stopnia $15$ interpolujacy $1/(1 + x^2)$ z wykorzystaniem wielomianu Czebyszewa],
    image("./plots/1x2_cz15.svg", width: 60%)
)