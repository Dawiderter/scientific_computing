#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

#set document(
    title: "Obliczenia Naukowe - Lista 5",
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
    *Lista nr 5* 
])

#show link: underline

= Problem rozwiązywania układu równań liniowych

== Definicja
W tym problemie szukamy wektora rozwiązań $x in RR^n$, który rozwiązuje zadany układ równań:
$ a_11 x_1 + a_12 x_2 + dots + a_1n x_n = b_1 $
$ a_21 x_1 + a_22 x_2 + dots + a_2n x_n = b_2 $
$ dots $
$ a_(n 1) x_1 + a_(n 2) x_2 + dots + a_(n n) x_n = b_n $

Możemy to też zapisać macierzowo dla zadanej macierzy $A in RR^(n times n)$ i wektora $b in RR^n$:
$ A x = b $

== Metoda eliminacja Gaussa
Metoda składa się z serii kroków. W każdym wykorzystujemy jedno z równań, żeby wyeliminować jedną niewiadomą z pozostałych równań. Natomiast na końcu korzystamy z prostego podstawiania. Dla przykładu:
$ 1: a_11 x_1 + a_12 x_2 + a_13 x_3 = b_1 $
$ 2: a_21 x_1 + a_22 x_2 + a_23 x_3 = b_2 $ 
$ 3: a_31 x_1 + a_32 x_2 + a_33 x_3 = b_3 $
Możemy usunąć z równań $2$ i $3$ niewiadomą $x_1$ poprzez odjęcie od nich przeskalowanego równania $1$ (odpowiednio przez $a_21/a_11$ i $a_31/a_11$):
$ 1: a_11 x_1 + a_12 x_2 + a_13 x_3 = b_1 $
$ 2: a'_22 x_2 + a'_23 x_3 = b'_2 $ 
$ 3: a'_32 x_2 + a'_33 x_3 = b'_3 $
Ten krok możemy powtórzyć, tym razem wykorzystując równanie $2$ do usunięcia niewiadomej $x_2$ z równania $3$.
$ 1: a_11 x_1 + a_12 x_2 + a_13 x_3 = b_1 $
$ 2: a'_22 x_2 + a'_23 x_3 = b'_2 $ 
$ 3: a''_33 x_3 = b''_3 $
Poprzez wykorzystywanie jedynie operacji elementarnych uzyskany układ jest równoważny z układem początkowym i do tego trywialny do rozwiązania. Z równania $3$ otrzymujemy wartość niewiadomej $x_3$, którą następnie podstawiamy do równania $2$ i wyliczamy niewiadomą $x_2$. Obydwie poznane niewiadome podstawiamy do równania $1$ i otrzymujemy $x_1$, tym samym rozwiązując układ równań.

== Rozkład LU
Cały proces eliminacji Gaussa możemy zapisać w postaci działań na macierzach. Realizacja kroku $k$ algorytmu możemy zapisać jako:
$ A^((k+1)) = L^((k)) A^((k)) quad b^((k+1)) = L^((k)) b^((k)) $
$ L^((k)) = mat(
  delim: "[",
  1;
  "", 1;
  "",, dots.down;
  "",,, 1;
  "",,, -l_(k+1, k), 1;
  "",,, -l_(k+2, k),, 1;
  "",,, dots.v,,, dots.down;
  "",,, -l_(n, k),,,,1;
) $
$ l_(i k) = a^((k))_(i k) / a^((k))_(k k) $
Macierze $L^((k))$ składają się z jedynek na przekątnej i współczynników skalujących $l_(i k)$ w kolumnie $k$. Przemnożenie przez tą macierz powoduje wyzerowanie czynników przy niewiadomej $x_k$ od równania $k + 1$ do $n$.

W wyniku tych nakładania tych działań uzyskujemy macierz górną trójkątną $U$:
$ U = L^((n)) dots L^((2)) L^((1)) A $
Inaczej:
$ A = L^(1)^(-1) L^(2)^(-1) dots L^(n)^(-1) U $
Co składamy do postaci: 
$ A = L U $
Po przeliczeniu dochodzimy, że macierz $L$ jest postaci:
$ L = mat(
  delim: "[",
  1;
  l_21,1;
  l_31,l_32,1;
  dots.v,dots.v,dots.v,dots.down;
  l_(n 1),l_(n 2),l_(n 3),dots,1
) $
Teraz rozwiązanie układu równań:
$ L U x = b $
Sprowadza się do rozwiązania dwóch równań, które ze względu na trójkątną postać macierzy, stają się trywialne:
$ L y = b quad U x = y $

== Wybór elementu głównego
Algorytm w takiej postaci zawsze używa równania $1$ do wyeliminowania niewiadomej $x_1$, równania $2$ do wyeliminowania $x_2$, itd. Jednak jak wiemy zamiana równań miejscami nie zmieni rozwiązań danego układu. Równie dobrze możemy do wyeliminowania $x_1$ wykorzystać dowolne równanie.

To pozwala rozwiązać problem, gdy w wyniku działania algorytmu, element główny - $a_(k k)^((k))$ - stanie się zerem lub będzie bliski zeru. Dzielenie przez niego może się wiązać z wprowadzeniem dużego błędu numerycznego.

Częściowy wybór elementu głównego polega na znalezieniu elementu maksymalnego pod względem modułu w kolumnie $k$ wśród pozostałych równań: $ |a_(p k)^((k))| = max_(k <= i <= n)|a_(i k)^((k))| $
Wtedy następuje zamiana miejscami równania $p$ z równaniem $k$. Ostatecznie skończymy z pewną permutacją $P$ oryginalnej macierzy:
$ L U = P A $
Stąd w celu rozwiązania układu należy rozwiązać dwa równania:
$ L y = P b quad U x = y $

== Złożoność obliczeniowa i pseudokod

W implementacji komputerowej rozkładu $L U$ nie potrzebujemy dodatkowej pamięci, ponieważ obydwie macierze mieszczą się w miejscu oryginalnej macierzy $A$.

#algorithm({
  import algorithmic: *
  Function("Rozkład-LU", args: ($a in RR^(n times n)$,), {
    For(cond: $k "from" 1 "to" n-1$ ,{
      For(cond: $i "from" k+1 "to" n$ ,{
        Assign($l$, $a_(i k) / a_(k k)$)
        For(cond: $j "from" k+1 "to" n$ ,{
          Assign($a_(i j)$, $a_(i j) - l dot a_(k j)$)
        })
        Assign($a_(i k)$, $l$)
      })
    })
    Return($a$)
  })
})

Żeby nie robić niepotrzebnej pracy poprzez kopiowanie zawartości wierszy z jednego miejsca w pamięci komputera do drugiego, wykorzystujemy wektor permutacji $p$. Na początku zaczyna jako permutacja $[1,2,dots,n]$. Zamiany wierszy realizujemy jako zamiana elementów tej permutacji. $p_i$ mówi nam które z równań (według oryginalnej numeracji) jest teraz na miejscu równania $i$.

#algorithm({
  import algorithmic: *
  Function("Rozkład-LU-Z-Wyborem", args: ($a in RR^(n times n)$,), {
    Assign($p$, $[1, 2, dots, n]$)
    For(cond: $k "from" 1 "to" n-1$ ,{
      Assign($m$, $"argmax"_(k <= i <= n) |a_(p_i k)|$)
      Assign($p_m, p_k$, $p_k, p_m$)
      For(cond: $i "from" k+1 "to" n$ ,{
        Assign($l$, $a_(p_i k) / a_(p_k k)$)
        For(cond: $j "from" k+1 "to" n$ ,{
          Assign($a_(p_i j)$, $a_(p_i j) - l dot a_(p_k j)$)
        })
        Assign($a_(p_i k)$, $l$)
      })
    })
    Return($a, p$)
  })
})


Wnioskując z prostego pseudokodu, oba algorytmy wykonują się w czasie $O(n^3)$.

#figure(
  caption: [Czas znajdywania rozkładu $L U$ tradycyjnym algorytmem],
  image("./plots/standard_comp_time.png", width: 80%)
)

= Adaptacja algorytmu dla specjalnych macierzy
== Opis problemu
W niektórych środowiskach ma się do czynienia z macierzami o rozmiarach rzędu setek tysięcy, gdzie rozwiązywanie równania $A x = b$ przy pomocy tradycyjnego algorytmu eliminacji Gaussa staje się nieosiągalne. Często da się jednak wykorzystać specjalną strukturę tych macierzy do uproszczenia obliczeń.

W tym zadaniu mamy do czynienia z macierzą, której jedyne elementy niezerowej są podzielone na bloki znajdujące się przy przekątnej. Zadany jest rozmiar bloku $l$ i podzielny przez niego rozmiar macierzy $n$. Liczba bloków to $v = n/l$.

$ A_k = mat(
    delim: "[",
    a_11, a_12, dots, a_(1l);
    a_21, a_22, dots, a_(2l);
    dots.v,dots.v, dots.down, dots.v;
    a_(l 1), a_(l 2), dots, a_(l l);
  )  
  quad 
  B_k = mat(
    delim: "[",
    0, dots, 0, b_1^k;
    0, dots, 0, b_2^k;
    dots.v, , dots.v, dots.v;
    0, dots, 0, b_l^k;
  ) 
  quad
  C_k = mat(
    delim: "[",
    c_1^k, 0, dots, 0;
    0, c_2^k, , dots.v;
    dots.v, , dots.down, 0;
    0, dots, 0, c_l^k;
  )
$

$ A = mat(
  delim: "[",
  A_1, C_1;
  B_2, A_2, C_2;
  "", B_3, A_3, C_3;
  "",, dots.down, dots.down, dots.down;
  "",,B_(v-1), A_(v-1), C_(v-1);
  "",,,B_v, A_v, C_v;
) $

== Adaptacja rozkładu $L U$ bez wyboru elementu głównego
=== Pomysł
Do optymalizacji tego algorytmu wystarczy jedynie to, które elementy danych wierszy są niezerowe. Dla wizualizacji oznaczyłem elementy pochodzące z bloków typu $A_k$ jako $a$, z $B_k$ jako $b$, z $C_k$ jako $c$.
$ A = mat(
  delim: "[",
  a, a, c;
  a, a,,c;
  "", b, a, a, c;
  "", b, a, a,,c;
  "",,,b,a,a;
  "",,,b,a,a;
) $
Na tym przykładzie widać, że elementy niezerowe danego wiersza $i$ zaczynają się od jakiejś kolumny $s_i$ i kończą na kolumnie $t_i$. Obie z tych wartości zależą tylko od numeru wiersza $i$ oraz wartości $l$ i $n$, które opisują wygląd macierzy. 

Do wyliczenia wartości $s_i$ oraz $l_i$ najpierw potrzeba jest znać, jaki jest numer bloku, którego wartości znajdują się w tym wierszu. Wiersze z $i in [1,l]$ mają numer bloku $1$, z $i in [l+1,2l]$ mają $2$, itd. Tę liczbę dla danego wiersza $i$ można wyrazić jako $u_i = floor((i-1)/l)$.

Liczba $s_i$ to inaczej numer kolumny, gdzie pojawia się w tym wierszu element typu $b$ lub $1$, gdy w danym wierszu nie ma takiego elementu. Wystąpienie elementu $b$ zależy natomiast od numeru bloku. Konkretnie:
$ s_i = max{u_i dot l,1} = max{floor((i-1)/l) dot l,1} $

Podobnie liczba $t_i$ to inaczej kolumna, gdzie w tym wierszu znajduje się element typu $c$ lub $n$, gdy nie ma takiego elementu. To wyraża się zależnością:
$ t_i = min{i + l,n} $

Tak samo można spojrzeń na niezerowe elementy danej kolumny $j$. Kończą się na jakiejś liczbie $b_j$. Z uwagi na wystającą w lewo kolumnę elementów typu $b$, ta wartość zależy od tego, gdzie kończą się bloki $j + 1$.
$ b_j = min{(u_(j+1)+1) dot l,n} = min{(floor(j/l) + 1) dot l,n} $

Spójrzmy jak wygląda sytuacja w kroku $k$

$ mat(
  delim: "[",
  a_11, a_21, dots,,,dots;
  0, a_22, dots,,,dots,;
  dots.v, , dots.down,,,dots;
  0, dots, 0, a_(k k), a_(k k+1), dots, a_(k t_k), 0, dots,,,0;
  0, dots, 0, a_(k+1 k), a_(k+1 k+1), dots, a_(k+1 t_k), a_(k+1 t_(k+1)), 0, dots,,0;
  dots.v,, , dots.v,,,dots.v,dots.down,dots.down,,,dots.v;
  0, dots, 0, a_(b_k k), a_(b_k k+1), dots, a_(b_k t_k), dots, a_(b_k t_b_k), 0, dots,0;
  0, dots,0, 0,, dots;
  dots.v,,dots.v, dots.v,,dots;
) $

Skoro $b_k$ wyraża to gdzie kończą się niezerowe elementy kolumny $k$, to wystarczy wyzerować tą kolumnę jedynie w wierszach pomiędzy $k+1$ a $b_k$.
Podobnie skoro $t_k$ wyraża gdzie kończą się niezerowe elementy wiersza $k$, to tylko elementy kolumn od $k+1$ do $t_k$ będą brały udział w odejmowaniu.

Dla danych wierszy i kolumn $k$ liczby $t_k$ i $b_k$ nie zmieniają się w czasie działania algorytmu. Bierze się to z faktu, że ciągi $(t_k)_k$ i $(b_k)_k$ są niemalejące. Dla danego wiersza $i$ elementy zerowe o indeksach $j > t_k$ nadal pozostaną zerowe. Gdyby tak nie było, to znaczy że odjęliśmy od czynnika w tej kolumnie jakiś niezerowy czynnik z któregoś wiersza wyżej. Jednak każdy wiersz wyżej także ma element zerowy z tej kolumnie.

=== Pseudokod

#algorithm({
  import algorithmic: *
  Function("Adaptowany-Rozkład-LU", args: ($a$,$n$,$l$), {
    For(cond: $k "from" 1 "to" n-1$ ,{
      Assign($b$, $min((floor(k/l) + 1) dot l,n)$)
      Assign($t$, $min(k + l, n)$)
      For(cond: $i "from" k+1 "to" b$ ,{
        Assign($l$, $a_(i k) / a_(k k)$)
        For(cond: $j "from" k+1 "to" t$ ,{
          Assign($a_(i j)$, $a_(i j) - l dot a_(k j)$)
        })
        Assign($a_(i k)$, $l$)
      })
    })
    Return($a$)
  })
})

Liczbę operacji w danym kroku $k$ możemy ograniczyć z góry przez $l^2$. Zatem ostateczna złożoność tego algorytmu to jedynie $O(n l^2)$. Gdy $l$ ustalimy jako stałą, to możemy zapisać złożoność jako $O(n)$

Oryginalny algorytm rozwiązania układu przy pomocy rozkładu $L U$ miał złożoność $O(n^2)$. Tutaj też można zastosować wcześniejsze obserwacje do ograniczenia obliczeń.

#algorithm({
  import algorithmic: *
  Function("Adaptowany-Solve-LUxb", args: ($a$,$n$,$l$, $b$), {
    Assign($x$, $b$)
    For(cond: $k "from" 1 "to" n$ ,{
      Assign($s$, $max(floor((k-1)/l) dot l,1)$)
      For(cond: $i "from" s "to" k-1$ ,{
        Assign($x_k$, $x_k - x_i dot a_(k i)$)
      })
    })
    For(cond: $k "from" n "to" 1$ ,{
      Assign($t$, $min(k + l, n)$)
      For(cond: $i "from" k+1 "to" t$ ,{
        Assign($x_k$, $x_k - x_i * a_(k i)$)
      })
      Assign($x_k$, $x_k / a_(k k)$)
    })
    Return($x$)
  })
})

Znowu w każdym kroku obu pętel można ograniczyć z góry liczbę działań do $l$. Co daje ponownie złożoność $O(n)$.

== Adaptacja rozkładu $L U$ z wyborem elementu głównego
=== Problem
W przypadku, kiedy dopuścimy zamianę miejscami wierszy, tracimy część dobrych właściwości, które mieliśmy przy rozkładzie bez wyboru. Tym razem liczby $s_i$ i $t_i$ ulegają zmianom w czasie działania algorytmu i nie tworzą już niemalejących ciągów.
$ A = mat(
  delim: "[",
  "1:", a, a, a, c;
  "2:", a, a, a,  ,c;
  "3:", a, a, a,  ,  ,c;
  "4:", "", , b, a, a, a, c;
  "5:", "", , b, a, a, a,  ,c;
  "6:", "", , b, a, a, a,  ,  ,c;
  "7:", "", ,  ,  ,  , b, a, a, a;
  "8:", "", ,  ,  ,  , b, a, a, a;
  "9:", "", ,  ,  ,  , b, a, a, a;
) $
Na tym przykładzie można zauważyć, że zamiana wierszy w obrębie bloków (np. $1$ i $2$, $4$ i $6$, itd.) zmienia liczby $t_i$ dla tych wierszy, ale pozostawia taką samą $s_i$. Mogą się też zdarzyć zamiany wierszy pomiędzy blokami (np. $3$ i $4$), które zmieniają także liczby $s_i$. W specyficznym przypadku może dojść do zamiany wiersza $1$ z $9$ (ciąg zamian $1 <-> 3 <-> 6 <-> 9$), który spowoduje pojawienie się na samym dole wiersza, którego potencjalnie każdy element jest niezerowy. 

Okazuje się jednak, że nadal możemy bez problemu wyliczyć liczby $s'_i$ i $t'_i$ na podstawie wiersza. Trzeba jedynie wykorzystać do tego wektor permutacji $p$.
$ s'_i = s_p_i = max{floor((p_i-1)/l) dot l,1} $
$ t'_i = max_(1<=j<=i)t_p_j <= min{(floor(k/l)+2) dot l, n} $

*Uzasadnienie:* Najpierw zauważmy, że w kroku $k$ żadna liczba $b_j "dla" j >= k$ nie zmieni się. Wymagałoby to zamiany pomiędzy niesąsiadującymi blokami.

Tym samym w kroku $k$ maksymalnie może nastąpić zamiana z wierszem $b_k$. Wszystkie wiersze pomiędzy nimi w ramach odejmowania zostają "poszerzone". Stąd ograniczenie $t'_k <= t_b_k = min{(min{(floor(k/l) + 1) dot l,n}) + l, n} = min{(floor(k/l)+2) dot l, n}$.

W przypadku $s'_i$ nie ma problemu. Elementy pod przekątną i na lewo od kolumny $k$ nie biorą udziału w odejmowaniu, bo należą do macierzy $L$. Stąd zamiana wierszy powoduje jedynie zamiany pozycji elementu startowego w tych wierszach. 

=== Pseudokod
Ostateczny algorytm wykorzystuje wyżej podane ograniczenia i obserwacje.

#algorithm({
  import algorithmic: *
  Function("Adaptowany-Rozkład-LU-Z-Wyborem", args: ($a$,$n$,$l$), {
    Assign($p$, $[1, 2, dots, n]$)
    For(cond: $k "from" 1 "to" n-1$ ,{
      Assign($b$, $min((floor(k/l) + 1) dot l,n)$)
      Assign($t$, $min((floor(k/l)+2) dot l, n)$)
      Assign($m$, $"argmax"_(k <= i <= b) |a_(p_i k)|$)
      Assign($p_m, p_k$, $p_k, p_m$)
      For(cond: $i "from" k+1 "to" b$ ,{
        Assign($l$, $a_(p_i k) / a_(p_k k)$)
        For(cond: $j "from" k+1 "to" t$ ,{
          Assign($a_(p_i j)$, $a_(p_i j) - l dot a_(p_k j)$)
        })
        Assign($a_(p_i k)$, $l$)
      })
    })
    Return($a, p$)
  })
})

W każdym kroku liczbę operacji możemy ograniczyć z góry przez $l + l dot 2l$. Stąd pomimo wykonywania większej liczby operacji, udało się zachować złożoność $O(n)$. 

Tak samo sytuacja wygląda dla algorytmu rozwiązywania układu z jedną subtelnością. Kroki pierwszej pętli nie można ograniczyć przez $l$. Jednak, jak później przy optymalizacji pamięciowej będzie pokazane, całą pętle i tak możemy ograniczyć przez $O(n)$.
#algorithm({
  import algorithmic: *
  Function("Adaptowany-Solve-LUxb-Z-Wyborem", args: ($a$,$n$,$l$,$p$,$b$), {
    For(cond: $k "from" 1 "to" n$ ,{
      Assign($s$, $max(floor((p_k-1)/l) dot l,1)$)
      Assign($x$, $b_p_k$)
      For(cond: $i "from" s "to" k-1$ ,{
        Assign($x_k$, $x_k - x_i dot a_(p_k i)$)
      })
    })
    For(cond: $k "from" n "to" 1$ ,{
      Assign($t$, $min((floor(k/l)+2) dot l, n)$)
      For(cond: $i "from" k+1 "to" t$ ,{
        Assign($x_k$, $x_k - x_i * a_(p_k i)$)
      })
      Assign($x_k$, $x_k / a_(p_k k)$)
    })
    Return($x$)
  })
})

== Porównanie

Na tym dość ekstremalnym wykresie widać, jak dużą różnice daje zastosowanie zaadaptowanego algorytmy o liniowej złożoności. Także zgodnie z oczekiwaniami, algorytm z częściowym wyborem zajmuje więcej czasu, ale charakteryzuje się mniejszym błędem.

#figure(
  caption: [Porównanie zaadaptowanych algorytmów z tradycyjnym rozkładem $L U$],
  image("./plots/adapted_comp_time.svg",width: 80%)
)

#figure(
  caption: [Porównanie zaadaptowanych algorytmów ze sobą],
  image("./plots/just_adapted_comp_time.svg",width: 80%)
)

#figure(
  caption: [Porównanie błędów zaadaptowanych algorytmów ze sobą],
  image("./plots/just_adapted_comp_err.svg",width: 80%)
)

= Optymalizacja pamięciowa
== Lepsza struktura danych
Oprócz samego algorytmu potrzeba też zoptymalizować strukturę danych przechowującą macierz. Jeśli rozmiar macierzy ma sięgać setek tysięcy, to niemożliwym staje się przechowywanie jej w strukturze $O(n^2)$. Proponowana struktura będzie wykorzystywała fakt, że niezerowe elementy danego wiersza $i$ znajdują się między $s_i$ oraz $t_i$.

$ A = mat(
  delim: "[",
  "1:", a, a, a, c;
  "2:", a, a, a,  ,c;
  "3:", a, a, a,  ,  ,c;
  "4:", "", , b, a, a, a, c;
  "5:", "", , b, a, a, a,  ,c;
  "6:", "", , b, a, a, a,  ,  ,c;
  "7:", "", ,  ,  ,  , b, a, a, a;
  "8:", "", ,  ,  ,  , b, a, a, a;
  "9:", "", ,  ,  ,  , b, a, a, a;
) 
->
A' = mat(
  delim: "[",
  "1:",  , a, a, a, c;
  "2:",  , a, a, a,  ,c;
  "3:",  , a, a, a,  ,  ,c;
  "4:", b, a, a, a, c;
  "5:", b, a, a, a,  ,c;
  "6:", b, a, a, a,  ,  ,c;
  "7:", b, a, a, a;
  "8:", b, a, a, a;
  "9:", b, a, a, a;
) $

Ta struktura zajmuje już jedynie $n dot (2l + 1)$ pamięci. $a_(i,j)$ w $A$ odpowiada $a_(i, j-s_i+1)$ w $A'$. Jednak ta struktura nie zadziała w przypadku algorytmu rozkładu $L U$ z częściowym wyborem elementu głównego. Opiera się na pomyśle, że $t_i - s_i <= 2l + 1$, co nie jest spełnione w przypadku zamiany wierszy. Tam dochodziło do "poszerzania", kiedy następowały zamiany pomiędzy różnymi blokami. 

Jednak te zamiany następują w bardzo przewidywalny sposób. Jedyny moment, kiedy to się może stać, to na końcu bloku, kiedy $l | k$ i $k != n$ (zamiany w ramach tego samego bloku są załatwione poprzez już znajdujące się w strukturze puste pola na prawym końcu). Wtedy wiersz $k$ zamienia się z wierszem $i$ o większym $t_i$, przez co musi się "poszerzyć" do tej długości, co możemy ograniczyć przez $l$. Sumarycznie więc w wyniku takich "poszerzeń" pojawi się jedynie $n - l$ nowych potencjalnie niezerowych elementów.
Dodatkowo każdy z tych elementów będzie znajdował się w innej kolumnie. W związku z tym można je przechowywać w dodatkowym wektorze $u in RR^n$ i prosto się do niego odnosić.

Ostatecznie więc definiujemy mapowanie elementów pełnowymiarowej macierzy do elementów tej struktury:

$ a_(i,j) = cases(
  a'_(i,j - floor((i-1)/l) dot l + 1 ) "gdy" j <= (floor((i-1)/l)+2) dot l,
  u_j "w przeciwnym wypadku"
) $

Zakładamy, że zawsze będziemy się odwoływali jedynie do elementów potrzebnych do działania tego algorytmu.
Wykorzystujemy fakt, że "poszerzanie" jest jednoznaczne w stostunku do kolumn. W takim razie, jeżeli w trakcie działania algorytm będzie chciał odwołać się do wiersza poza jego oryginalnym $t_i$ (a właściwie to jego górnym ograniczeniem $(floor((i-1)/l)+2) dot l$ oznaczającym najbardziej na prawo wysuniętą kolumnę), to wiemy że doszło do "poszerzenia" i na podstawie kolumny decydujemy, który element wektora $u$ zwrócić.

Tym samym pamięć potrzebna na przechowanie takiej struktury to $n dot (2l + 2)$, co znaczy $O(n)$.

== Wyniki

#figure(
  caption: [Porównanie czasu rozwiązywania układu równań przy pomocy rozkładu $L U$],
  table(
    columns: 7,
    $n,l$,$16,4$,$10000,5$,$50000,4$,$100000,5$,$300000,4$,$500000,4$,
[Gauss],$5.201 dot 10^(-6) s$,
$0.002523 s$,$0.009766 s$,$0.02724 s$,$0.0539 s$,$0.09688 s$,
[Gauss z wyb.],$6.304 dot 10^(-6) s$,$0.007336 s$,$0.02121 s$,$0.05067 s$,$0.1129 s$,$0.1728 s$,
[LU],$3.448 dot 10^(-6) s$,$0.00248 s$,$0.01802 s$,$0.0274 s$,$0.06349 s$,$0.1035 s$,
[LU z wyb.],$1.067 dot 10^(-5) s$,$0.004479 s$,$0.04068 s$,$0.05085 s$,$0.1179 s$,$0.1741 s$,
  )
)

#figure(
  caption: [Porównanie czasu dla algorytmu rozkładu LU],
  image("./plots/adapted_comp_time_full.svg",width: 80%)
)

#figure(
  caption: [Porównanie błędu względnego rozwiązywania układu równań przy pomocy $L U$],
  table(
    columns: 7,  
    $n,l$,$16,4$,$10000,5$,$50000,4$,$100000,5$,$300000,4$,$500000,4$,
[Bez wyboru],$9.9 dot 10^(-15)$,$5.9 dot 10^(-14)$,$1.1 dot 10^(-13)$,$5.9 dot 10^(-14)$,$3.9 dot 10^(-13)$,$1.2 dot 10^(-13)$,
[Z wyborem],$4.9 dot 10^(-16)$,$3.6 dot 10^(-16)$,$4.1 dot 10^(-16)$,$3.1 dot 10^(-16)$,$4.1 dot 10^(-16)$,$4.1 dot 10^(-16)$,
  )
)

#figure(
  caption: [Porównanie błędów względnych dla algorytmu LU],
  image("./plots/adapted_comp_err_full.svg",width: 80%)
)

== Wnioski
Wykresy dowodzą, że udało się zaimplementować algorytm eliminacji Gaussa oraz rozkładu $L U$ w czasie liniowym i z liniową pamięcią. Pokazują też, że opłaca się dobry wybór elementu głównego. Poprawia błąd o dwa rzędy wielkości kosztem niecałego podwojenia czasu, który i tak jest wyjątkowo krótki. Sama eliminacja Gaussa wykonuje mniej operacji niż pełny rozkład $L U$, jednak okazała się jedynie nieznacznie szybsza.