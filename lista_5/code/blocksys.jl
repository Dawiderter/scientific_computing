# Autor: Dawid Walczak

module blocksys
    export FastAdaptedMatrix, getindex, setindex!,*,Vector,save, gaussElimination!, pivotedGaussElimination!, LU!, LUxb!, pivotedLU!, pivotedLUxb!

    import Base.:*

    "Struktura do optymalnego pamiętania specjalnej macierzy zgodnej z warunkami zadania, a także do pamiętania jej rozkładu LU (bez wyboru i z wyborem)"
    struct FastAdaptedMatrix
        inner::Matrix{Float64}
        n::Int
        l::Int
    end

    "Konstruuje macierz wypełnioną zerami"
    function FastAdaptedMatrix(n::Int, l::Int)
        return FastAdaptedMatrix(zeros(n,2*l+2),n,l)
    end

    "Czyta macierz z pliku"
    function FastAdaptedMatrix(filepath::String)
        lines = eachline(filepath)
        (size, rest) = Iterators.peel(lines)
        (n, l) = split(size)
        n = parse(Int, n)
        l = parse(Int,l)
        mat = FastAdaptedMatrix(n,l)
        for line in rest
            (i, j, val) = split(line)
            i = parse(Int, i)   
            j = parse(Int, j)
            val = parse(Float64, val)
            mat[i,j] = val
        end
        return mat
    end

    import Base.Vector

    "Czytanie wektora z pliku"
    function Vector(filepath::String)
        lines = eachline(filepath)
        (size, rest) = Iterators.peel(lines)
        n = parse(Int, size)
        vec = zeros(n)
        i = 1
        for line in rest
            val = parse(Float64, line)
            vec[i] = val
            i += 1
        end
        return vec
    end

    "Zapisywanie wektora do pliku"
    function save(filepath::String, x::Vector{Float64}, error::Union{Nothing, Float64} = nothing)
        open(filepath, "w") do file
            if !isnothing(error)
                println(file, error)
            end
            for x_i in x
                println(file, x_i)
            end
        end
    end

    "Zwraca element na który jest mapowany indeks i,j pełnej macierzy. Działa poprawnie jedynie dla indeksów używanych przez algorytmy zaimplementowane w tym module. Do prostego zapisywania wystarczy trzymać się tego, że poprawne indeksy dla wiersza i zawierają sie w przedziale [(i-1)÷l*l, ((i-1)÷l+2)*l]"
    function Base.getindex(a::FastAdaptedMatrix,i::Int,j::Int)
        # W ostatniej kolumnie przechowywane są rozszerzenia
        if j <= ((i-1)÷a.l+2)*a.l
            # Każdy wiersz jest przesunięty tak, że pierwszy element typu A, znajduje się w 2 kolumnie tej struktury
            s = ((i-1)÷a.l)*a.l
            return a.inner[i,j-s+1]
        else
            return a.inner[j,end]
        end
    end

    "Obowiązują te same zasady, co przy getindex"
    function Base.setindex!(a::FastAdaptedMatrix,v::Float64, i::Int,j::Int)
        # W ostatniej kolumnie przechowywane są rozszerzenia
        if j <= ((i-1)÷a.l+2)*a.l
            # Każdy wiersz jest przesunięty tak, że pierwszy element typu A, znajduje się w 2 kolumnie tej struktury
            s = ((i-1)÷a.l)*a.l
            a.inner[i,j-s+1] = v
        else
            a.inner[j,end] = v
        end
    end

    "Realizacja efektywnego mnożenia Ab macierzy przez wektor"
    function *(a::FastAdaptedMatrix, b::Vector{Float64})
        n = a.n
        l = a.l
        c = zeros(n)
        for k in 1:n
            s = max(((k-1)÷l)*l,1)
            t = min(k+l,n)
            for i in s:t
                c[k] += a[k,i] * b[i]
            end
        end
        return c
    end

    "Rozwiązuje efektywnie układ równań Ax = b dla specjalnej postaci macierzy. Nadpisuje przy tym argumenty A i b."
    function gaussElimination!(a::FastAdaptedMatrix,b::Vector{Float64})
        n = a.n
        l = a.l
        # Kolejne kroki
        for k in 1:(n-1)
            # Koniec tego bloku w kolumnach
            bt = min((k÷l+1)*l,n)
            # Koniec tego bloku w kolumnach
            t = min(k+l,n)
            # Zerowanie kolumny k do końca bt
            for i in (k+1):bt
                # Współczynnik l[i,k] 
                a[i,k] /= a[k,k]
                for j in (k+1):t
                    a[i,j] -= a[i,k] * a[k,j]
                end
                b[i] -= a[i,k] * b[k]
            end
        end

        # Podstawianie
        for k in reverse(1:n)
            t = min(k+l,n)
            for i in (k+1):t
                b[k] -= b[i] * a[k,i]
            end
            b[k] /= a[k,k]
        end

        return b
    end

    "Rozwiązuje efektywnie układ równań Ax = b dla specjalnej postaci macierzy. Implementuje algorytm eliminacji Gaussa z częściowym wyborem elementu głównego. Nadpisuje przy tym argumenty A i b."
    function pivotedGaussElimination!(a::FastAdaptedMatrix, b::Vector{Float64})
        n = a.n
        l = a.l
        # Pivot 
        p = [i for i in 1:n]
    
        # Kolejne kroki
        for k in 1:(n-1)
            # Koniec tego bloku w wierszach
            bt = min((k÷l+1)*l,n)
            # Ograniczenie na koniec tego bloku w kolumnach
            t = min((k÷l+2)*l,n)
            # Znalezienie maksymalnego elementu w kolumnie k
            m = k
            for i in (k+1):bt
                if abs(a[p[i],k]) > abs(a[p[m],k])
                    m = i
                end
            end
    
            # Zamiana wiersza k z m
            (p[k], p[m]) = (p[m], p[k])
            (b[k], b[m]) = (b[m], b[k])
    
            # Zerowanie kolumny k do końca bloku
            for i in (k+1):bt
                # Współczynnik l[i,k] 
                a[p[i],k] /= a[p[k],k]
                # Modyfikacja reszty wiersza do końca bloku
                for j in (k+1):t
                    a[p[i],j] -= a[p[i],k] * a[p[k],j]
                end
                b[i] -= a[p[i],k] * b[k]
            end
        end

        # Podstawianie
        for k in reverse(1:n)
            t = min((k÷l+2)*l,n)
            for i in (k+1):t
                b[k] -= b[i] * a[p[k],i]
            end
            b[k] /= a[p[k],k]
        end

        return b
    end

    "Rozkłada efektywnie macierz na macierze L i U. Są one optymalnie przechowywane w miejscu wejściowej macierzy."
    function LU!(a::FastAdaptedMatrix)
        n = a.n
        l = a.l
        # Kolejne kroki
        for k in 1:(n-1)
            # Koniec tego bloku w kolumnach
            bt = min((k÷l+1)*l,n)
            # Koniec tego bloku w kolumnach
            t = min(k+l,n)
            # Zerowanie kolumny k do wiersza bt
            for i in (k+1):bt
                # Współczynnik l[i,k] 
                a[i,k] /= a[k,k]
                for j in (k+1):t
                    a[i,j] -= a[i,k] * a[k,j]
                end
            end
        end
        return a
    end
    
    "Rozwiązuje efektywnie równanie LUx = b. Zakłada, że na wejściu podana jest już rozłożona macierz. Nadpisuje wejściowy argument b."
    function LUxb!(a::FastAdaptedMatrix,b::Vector{Float64})
        n = a.n
        l = a.l
        # Rozwiązywanie Ly = b
        for k in 1:n
            s = max(((k-1)÷l)*l,1)
            for i in s:(k-1)
                b[k] -= b[i] * a[k,i]
            end
        end
        
        # Rozwiązywanie Ux = y
        for k in reverse(1:n)
            t = min(k+l, n)
            for i in (k+1):t
                b[k] -= b[i] * a[k,i]
            end
            b[k] /= a[k,k]
        end
    
        return b
    end

    "Rozkłada efektywnie macierz na macierze L i U z częściowym wyborem elementu głównego. Są one optymalnie przechowywane w miejscu wejściowej macierzy."
    function pivotedLU!(a::FastAdaptedMatrix)
        n = a.n
        l = a.l
        # Pivot 
        p = [i for i in 1:n]
    
        # Kolejne kroki
        for k in 1:(n-1)
            # Koniec tego bloku w wierszach
            bt = min((k÷l+1)*l,n)
            # Ograniczenie na koniec tego bloku w kolumnach
            t = min((k÷l+2)*l,n)
            
            # Znalezienie maksymalnego elementu w kolumnie k
            m = k
            for i in (k+1):bt
                if abs(a[p[i],k]) > abs(a[p[m],k])
                    m = i
                end
            end
            
            # Zamiana wiersza k z m
            (p[k], p[m]) = (p[m], p[k])
    
            # Zerowanie kolumny k do końca bloku
            for i in (k+1):bt
                # Współczynnik l[i,k] 
                a[p[i],k] /= a[p[k],k]
                # Modyfikacja reszty wiersza do końca bloku
                for j in (k+1):t
                    a[p[i],j] -= a[p[i],k] * a[p[k],j]
                end
            end
        end
        return (a,p)
    end
    
    "Rozwiązuje efektywnie równanie LUx = Pb. Zakłada, że na wejściu podana jest już rozłożona macierz."
    function pivotedLUxb!(a::FastAdaptedMatrix,p::Vector{Int},b::Vector{Float64})
        n = a.n
        l = a.l
        x = zeros(n)
        
        # Rozwiązywanie Ly = Pb
        for k in 1:n
            x[k] = b[p[k]]
            # Początek niezerowych elementów w wierszu k zależy od tego jaki wiersz się tam tak naprawdę znajduje (p[k])
            s = max(((p[k]-1)÷l)*l,1)
            for i in s:(k-1)
                x[k] -= x[i] * a[p[k],i]
            end
        end
        
        # Rozwiązywanie Ux = y
        for k in reverse(1:n)
            t = min((k÷l+2)*l,n)
            for i in (k+1):t
                x[k] -= x[i] * a[p[k],i]
            end
            x[k] /= a[p[k],k]
        end
    
        return x
    end
end