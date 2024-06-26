#import "@preview/tablex:0.0.6": tablex, colspanx

#set document(
    title: "Obliczenia Naukowe - Lista 1",
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
    *Lista nr 1* 
])

#let fl = $\f\l$
#let macheps = $\m\a\c\h\e\p\s$
#let eta = $\e\t\a$

= Zadanie 1
== Opis problemu
Pierwszy problem polega na wyznaczeniu w sposób iteracyjny istotnych stałych związanych z arytmetyką zmiennoprzecinkową w różnych precyzjach.
- Epsilon maszynowy : najmniejszy $macheps > 0$ taki że $fl(1.0 + macheps) > 1.0$ i $fl(1.0+macheps) = 1+macheps$
- Eta : najmniejsza $eta$ taka że $eta > 0.0 $
- Max : największa liczba możliwa do zapisania w danym systemie
== Opis algorytmu 
=== Epsilon maszynowy
Szukając $macheps$, sprawdzam kolejne potęgi $1/2$, dopóki nie dojdę do takiej, która w wyniku dodania do $1.0$ da $1.0$. Według standardu IEEE 754 zaokrąglenia następują do najbliższej parzystej liczbie (czyli kończącej się na bicie $0$). Z racji że $1.0$ jest zgodnie z tym parzysta, to algorytm zakończy się rzeczywiście przy pierwszej takiej potędze $1/2$, że wynik dodania do $1.0$ nie mieści się dokładnie w precyzji. Wtedy poprzednia potęga, to szukany $macheps$.
#figure(caption: [Algorytm liczenia $macheps$],
    ```
    eps = 1.0
    while (1.0 + eps / 2.0) > 1.0
        eps /= 2.0
    end
    return eps
    ```
)
=== Eta
Na podobnej zasadzie szukam liczby $eta$. Sprawdzam kolejne potęgi $1/2$ aż któraś nie zmieści się już w precyzji i zaokrągli do $0.0$, które jest parzyste. Wtedy poprzednia potęga to $eta$.

#figure(caption: [Algorytm liczenia $eta$],
    ```
    eta = 1.0
    while (eta / 2.0) > 0.0 
        eta /= 2.0
    end
    return eta
    ```
)
=== Max
Tutaj podzieliłem algorytm na dwie części. Najpierw "maksymalizuje cechę", szukając największej potęgi $2$ mieszczącej się w precyzji. Następnie "wypełniam mantysę", dodając po kolei coraz mniejsze potęgi $2$, aż nie dojdę do liczby, której nie można już zapisać dokładnie w danej precyzji i spowoduje overflow. Wtedy poprzednia liczba to max. 
#pagebreak()
#figure(caption: "Algorytm liczenia max",
    ```
    max = 1.0
    while !isinf(max * 2.0)
        max *= 2.0
    end
    step = max / 2.0
    while !isinf(max + step)      
        my_max += step
        step /= 2.0
    end
    return max
    ```
)
== Wyniki
#figure(
    caption: "Wyniki otrzymane w przeprowadzonych doświadczeniach" ,
    table(
        columns: (auto, auto, auto, auto),
        align: horizon,
        [], [Float16], [Float32], [Float64],
        [$macheps$], [$0.000977$], [$1.1920929 dot 10^(-7)$], [$2.220446049250313 dot 10^(-16)$],
        [$eta$], [$6.0 dot 10^(-8)$], [$1.0 dot 10^(-45)$], [$5.0 dot 10^(-324)$],
        [$\m\a\x$], [$6.55 dot 10^4$], [$3.4028235 dot 10^38$], [$1.7976931348623157 dot 10^308$]
    )
)

#figure(
    caption: "Wartości wyliczone przy pomocy biblioteki standardowej",
    table(
        columns: (auto, auto, auto, auto),
        align: horizon,
        [], [Float16], [Float32], [Float64],
        [`eps(T)`], [$0.000977$], [$1.1920929 dot 10^(-7)$], [$2.220446049250313 dot 10^(-16)$],
        [`nextfloat(T(0.0))`], [$6.0 dot 10^(-8)$], [$1.0 dot 10^(-45)$], [$5.0 dot 10^(-324)$],
        [`floatmax(T)`], [$6.55 dot 10^4$], [$3.4028235 dot 10^38$], [$1.7976931348623157 dot 10^308$]
    )
)

// float x_1 = 1.19209289550781250000000000000000000e-7F
// float x_2 = ((double)2.22044604925031308084726333618164062e-16L)
// float x_3 = 3.40282346638528859811704183484516925e+38F
// float x_4 = ((double)1.79769313486231570814527423731704357e+308L)

#figure(
    caption: "Wartości znajdujące się w pliku nagłówkowym float.h",
    table(
        columns: (auto, auto, auto),
        align: horizon,
        [], [float], [double],
        [`EPSILON`], [$1.1920928955078125 dot 10^(-7)$], [$2.22044604925031308 dot 10^(-16)$],
        [`MAX`], [$3.4028234663852886 dot 10^38$], [$1.79769313486231571 dot 10^308$],
    )
)

== Wnioski i odpowiedzi
#line(length: 100%)
- _Jaki ma związek macheps z precyzją arytmetyki?_
_macheps_ oznacza względną odległość pomiędzy kolejnymi liczbami maszynowymi. Natomiast precyzja arytmetyki oznacza największy względny błąd reprezentacji. Stąd jeżeli mamy do czynienia z zaokrąglaniem to $"precyzja" = 1/2 macheps$, a gdy z obcinaniem to $"precyzja" = macheps$. 
#line(length: 100%)
- _Jaki ma związek liczba eta z liczbą $"MIN"_"sub"$?_
$"MIN"_"sub"$ to najmniejsza liczba większa od zera możliwa do zapisania w danej precyzji. Należy do liczb zdenormalizowanych. Zgodnie z definicją jest równa naszej liczbie $eta$. 
#pagebreak()
#line(length: 100%)
- _Co zwracają `floatmin(T)` i jaki jest ich związek z $"MIN"_"nor"$?_
`floatmin(Float32)` i `floatmin(Float64)` zwracają kolejno liczby $1.1754944 dot 10^(-38)$ i $2.2250739 dot 10^(-308)$. Zgodnie z dokumentacją są to najmniejsze liczby znormalizowane możliwe do zapisania w danej precyzji. Tym samym są równe $"MIN"_"nor"$. 


= Zadanie 2
Według Kahana można uzyskać epsilon maszynowy wyliczając wyrażenie `3(4/3-1)-1`. Stwierdzenie to zweryfikowałem w wielu precyzjach w języku Julia za pomocą prostych poleceń:
```jl
Float16(3) * (Float16(4) / Float16(3) - Float16(1)) - Float16(1) == -eps(Float16)
```
$->$ true

```jl
Float32(3) * (Float32(4) / Float32(3) - Float32(1)) - Float32(1) == eps(Float32)
```
$->$ true

```jl
Float64(3) * (Float64(4) / Float64(3) - Float64(1)) - Float64(1) == -eps(Float64)
```
$->$ true \
Żeby to zrozumieć wystarczy spojrzeć na kolejne etapy liczenia tego wyrażenia. Dla przykładu użyję arytmetyki Float16.

#figure(caption: "Kolejno wykonywane operacje i ich wyniki w Float16",
    table(
        columns: (auto, auto),
        align: horizon,
        inset: 10pt,
        `4/3`, $(1.0101010101)_2 dot 2^0$,
        `4/3-1`, $(1.0101010100)_2 dot 2^(-2)$, // Widać od razu że 4/3 - 1 to nie to samo co 1/3
        `3(4/3-1)`, $(1.1111111110)_2 dot 2^(-1)$,
        `3(4/3-1)-1`, $-(1.0000000000)_2 dot 2^(-11)$,
    )
)
Wiadomo, że wynikiem `3(4/3-1)` powinno być $1.0$, a jednak w arytmetyce zmiennoprzecinkowej otrzymałem wynik, który wynosi $1 plus.minus macheps$. Różnica w znaku jest związana z tym, że okres $1/3$ w rozwinięciu dwójkowym ma długość $2$ i zależnie od tego czy precyzja jest parzysta (Float32), czy nieparzysta (Float16, Float64), utniemy dokładny wynik na ostatnim bicie $0$ albo na $1$.

= Zadanie 3
Ten problem polega na sprawdzeniu równomiernego rozmieszczenia liczb maszynowych na odcinkach $[1,2]$, $[1/2,1]$, $[2,4]$. Zgodnie z teorią z wykładu wiem, że odległość pomiędzy dwiema sąsiednimi liczbami maszynowymi z cechą $c$ wynosi $2^(c-(t-1))$. Podstawiając dla naszych odcinków kolejno $c = 0, -1, 1$ oraz $t-1 = 52$, otrzymałem $2^(-52), 2^(-53), 2^(-51)$. Z racji, że te odcinki mają w sobie bardzo dużo liczb, nie sprawdzałem każdej z nich, a jedynie wybrałem paru przedstawicieli i sprawdzałem ich reprezentacje bitową. Eksperyment potwierdził teorię.

#figure(caption: [Test dla liczb z odcinka $[1,2]$],
    table(
        inset: 7pt,
        columns: (auto, auto),
        [*Liczba*], [*Reprezentacja binarna*],
        $1.0$, `0:01111111111:0000000000000000000000000000000000000000000000000000`,
        $1.0 + 2^(-52)$, `0:01111111111:0000000000000000000000000000000000000000000000000001`,
        $1.0 + 2^(-51)$, `0:01111111111:0000000000000000000000000000000000000000000000000010`,
        $4/3$,
        `0:01111111111:0101010101010101010101010101010101010101010101010101`,
        $4/3 + 2^(-52)$,
        `0:01111111111:0101010101010101010101010101010101010101010101010110`,
        $2.0$,
        `0:10000000000:0000000000000000000000000000000000000000000000000000`,
        $2.0 - 2^(-52)$,
        `0:01111111111:1111111111111111111111111111111111111111111111111111`
    )
)

#figure(caption: [Test dla liczb z odcinka $[2,4]$],
    table(
        inset: 7pt,
        columns: (auto, auto),
        [*Liczba*], [*Reprezentacja binarna*],
        $2.0$, `0:10000000000:0000000000000000000000000000000000000000000000000000`,
        $2.0 + 2^(-51)$, `0:10000000000:0000000000000000000000000000000000000000000000000001`,
        $4.0$,
        `0:10000000001:0000000000000000000000000000000000000000000000000000`,
        $4.0 - 2^(-51)$,
        `0:10000000000:1111111111111111111111111111111111111111111111111111`
    )
)

#figure(caption: [Test dla liczb z odcinka $[1/2,1]$],
    table(
        inset: 7pt,
        columns: (auto, auto),
        [*Liczba*], [*Reprezentacja binarna*],
        $0.5$, `0:01111111110:0000000000000000000000000000000000000000000000000000`,
        $0.5 + 2^(-53)$, `0:01111111110:0000000000000000000000000000000000000000000000000001`,
        $1.0$, `0:01111111111:0000000000000000000000000000000000000000000000000000`,
        $1.0 - 2^(-53)$,
        `0:01111111110:1111111111111111111111111111111111111111111111111111`
    )
)




= Zadanie 4
Celem tego zadania jest wyznaczenie najmniejszej takiej liczby $1 < x < 2$, że $fl(x dot fl(1/x)) != 1$. Zgodnie z poprzednim zadaniem wystarczy iteracyjnie przesuwać się od $1$ krokami $2^(-52)$, żeby nie pominąć żadnej liczby w przedziale $[1,2]$.

```
x = 1.0
while x * (1.0 / x) == 1.0
    x += 2^(-52)
end
return x
```

Wynikiem była liczba $1.000000057228997096814282485865987837314605712890625$. Albo inaczej $257736490$ liczba z kolei następująca po liczbie $1$.

= Zadanie 5
== Opis problemu 
Problem polega na zbadaniu wyliczenia iloczynu skalarnego wektorów $x$ i $y$ poprzez dodawanie w różnych kolejnościach.
#grid(
    columns: (10%, auto),
    row-gutter: 10pt,
    align(right,$x =$), $space [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]$, 
    align(right,$y =$), $space [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]$,
)
Te dwa wektory są do siebie prawie prostopadłe, przez co iloczyn skalarny jest bliski zeru. Dokładny wynik powinien wynieść $-1.00657107000000 dot 10^(-11)$.
== Opis algorytmu
Zacząłem od wyliczenia wektora składającego się z wymnożonych elementów $x$ i $y$.
#grid(
    columns: (10%, auto),
    row-gutter: 10pt,
    align(right,$m =$), $space [x_1 y_1,x_2 y_2, x_3 y_3, x_4 y_4, x_5 y_5]$, 
    align(right,$m approx$), $space [4040.046, -2759471.3, -31.64292, 2755462.9, 0.0000557]$,
)
Kolejne metody liczenia iloczynu skalarnego realizuję poprzez sumowanie elementów wektora $m$ w różnych kolejnościach.
== Wyniki
#figure(caption: "Wyniki w precyzji Float64", kind: table, tablex(
    columns: (auto, auto, auto, auto),
    colspanx(4)[#align(center, [*Float64*])],
    [*Kolejność*], [*Działanie*], [*Wynik*], [*Błąd względny*],
    [W przód], $m_1 + m_2 + m_3 + m_4 + m_5$, $1.0251881 dot 10^(-10)$, $11.185$,
    [W tył], $m_5 + m_4 + m_3 + m_2 + m_1$, $-1.5643309 dot 10^(-10)$, $14.541$,
    [Od max do min], $(m_4 + m_1 + m_5) + (m_2 + m_3)$, $0.0$, $1.0$,
    [Od min do max], $(m_5 + m_1 + m_4) + (m_3 + m_2)$, $0.0$,
    $1.0$
))

#figure(caption: "Wyniki w precyzji Float32", kind: table, tablex(
    columns: (auto, auto, auto, auto),
    colspanx(4)[#align(center, [*Float32*])],
    [*Kolejność*], [*Działanie*], [*Wynik*], [*Błąd względny*],
    [W przód], $m_1 + m_2 + m_3 + m_4 + m_5$, $-0.4999443$, $4.9668 dot 10^10$,
    [W tył], $m_5 + m_4 + m_3 + m_2 + m_1$, $-0.4543457$, $4.5138 dot 10^10$,
    [Od max do min], $(m_4 + m_1 + m_5) + (m_2 + m_3)$, $-0.5$, $4.9674 dot 10^10$,
    [Od min do max], $(m_5 + m_1 + m_4) + (m_3 + m_2)$, $-0.5$,
    $4.9674 dot 10^10$
))
== Wnioski
Najmniejszym błędem zostało obarczone sumowanie od tyłu w precyzji Float64. Natomiast jakakolwiek próba sumowania we Float32 skończyła ogromnym błędem względnym rzędu $10^10$.

= Zadanie 6
W tym zadaniu obliczam wartość dwóch różnych wyrażeń $f(x)$ i $g(x)$, które są sobie matematycznie równoważne, dla zmniejszającego się argumentu $x = 8^(-1), 8^(-2), 8^(-3), dots$.

$ f(x) = sqrt(x^2 + 1) - 1 $
$ g(x) = x^2/(sqrt(x^2 + 1) + 1) $
 
#figure(
    caption: "Porównanie wyliczania obu wyrażeń",
    table(
        columns: 3,
        $x$, $f(x)$, $g(x)$,
        $8^(-1)$, $7.78221854 dot 10^(-03)$, $7.78221854 dot 10^(-03)$,
        $8^(-2)$, $1.22062863 dot 10^(-04)$, $1.22062863 dot 10^(-04)$,
        $8^(-3)$, $1.90734681 dot 10^(-06)$, $1.90734681 dot 10^(-06)$,
        $8^(-4)$, $2.98023219 dot 10^(-08)$, $2.98023219 dot 10^(-08)$,
        $8^(-5)$, $4.65661287 dot 10^(-10)$, $4.65661287 dot 10^(-10)$,
        $8^(-6)$, $7.27595761 dot 10^(-12)$, $7.27595761 dot 10^(-12)$,
        $8^(-7)$, $1.13686838 dot 10^(-13)$, $1.13686838 dot 10^(-13)$,
        $8^(-8)$, $1.77635684 dot 10^(-15)$, $1.77635684 dot 10^(-15)$,
        $8^(-9)$, $0.00000000$, $2.77555756 dot 10^(-17)$,
        $8^(-10)$, $0.00000000$, $4.33680869 dot 10^(-19)$,
        $8^(-11)$, $0.00000000$, $6.77626358 dot 10^(-21)$,
        $dots$, $dots$, $dots$,
        $8^(-48)$, $0.00000000$, $1.00538234 dot 10^(-87)$,
        $8^(-49)$, $0.00000000$, $1.57090991 dot 10^(-89)$,
        $8^(-50)$, $0.00000000$, $2.45454673 dot 10^(-91)$,

    )
)

Choć wyrażenia były równoznaczne, to szybko zaczęły od siebie odbiegać. Problem pojawia się w wyrażeniu $x^2 + 1$ i jest powodowany przez dodawanie do $1$ liczby względnie bardzo małej. Gdy $x = 8^(-9) = 2^(-27)$ to $x^2 = 2^(-54)$, a jako że typ Float64 przeznacza 53 bity na mantysę, to wynik dodawania $x^2 + 1$ jest obcinany do wartości $1.0$. Wyrażenie $g(x)$ nie jest obarczone tym problemem z powodu posiadania dodatkowo $x^2$ w liczniku i tym samym daje bliższe prawdzie wyniki.

= Zadanie 7
== Opis problemu
Do wyliczenia przybliżonej pochodnej funkcji w punkcie można skorzystać z definicji granicznej. Tym samym otrzymuje się taki wzór:
$ f'(x_0) approx accent(f, tilde)'(x_0) = (f(x_0 + h) - f(x_0))/h $
To zadanie polega na wyliczeniu wartości i błędu pochodnej funkcji $sin(x) + cos(3x)$ w punkcie $x_0 = 1$ dla $h = 2, 2^(-1), 2^(-2), dots, 2^(-54)$.
Pochodną wyliczyłem ręcznie i wyniosła ona $f'(x) = cos(x) - 3sin(3x)$, co w punkcie $x_0 = 1$ daje w przybliżeniu wartość $0.1169422817$.
#pagebreak()
== Wyniki
#figure(caption: "Wyliczone przybliżone wartości pochodnej", image("./plot_f.svg"))
#figure(caption: "Błąd bezwzgledny przybliżeń (w skali logarytmicznej)", image("./plot_diff.svg"))
== Wnioski
Z wykresów można odczytać, że od pewnego miejsca błąd zaczyna rosnąć zamiast maleć. Minimalny błąd zostaje osiągnięty dla $n = 28$. Jest to złożenie paru czynników. Pierwszy związany jest z odejmowaniem bliskich siebie liczb w wyrażeniu $f(x_0+h) - f(x_0)$. Zgodnie z wykładem takie odejmowanie $x - y$ wiąże się z dużym mnożnikiem błędu reprezentacji $(|x| + |y|)/(|x-y|)$. Następnie to wyrażenie jest dzielone przez przez $abs(h)$, i razem z tym błąd dostaje kolejny mnożnik $1/abs(h)$. Do pewnego momentu algorytm szybciej zbiega niż jest w stanie popsuć to błąd, ale od pewnego momentu zostaje przez niego wyprzedzony. Dodatkowo na samym końcu występuje anomalia, gdy wynik działania $1.0 + h$ nie mieści się już w precyzji i estymowana pochodna przyjmuje wartości $0.0$ i $-0.5$.