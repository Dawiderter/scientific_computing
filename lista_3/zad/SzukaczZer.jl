#Autor: Dawid Walczak

module SzukaczZer

export mbisekcji, msiecznych, mstycznych

#= 
Wyznacza rozwiązania równania f(x) = 0 metodą bisekcji
Zwraca czwórkę (r,v,it,err)
r - przybliżenie rozwiązania, 
v - wartość f(r), 
it - liczba wykonanych iteracji, 
err - 1 gdy funkcja nie zmienia znaku na [a,b] i 0 inaczej
=#
MAX_ITER = 1000

function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64) 
    left_val = f(a)
    right_val = f(b)
    inter = b - a
    if sign(left_val) == sign(right_val) 
        return (0,0,0,1)
    end

    for it in 0:MAX_ITER
        inter = inter / 2
        middle = a + inter

        middle_val = f(middle)
        if abs(inter) < delta || abs(middle_val) < epsilon
            return (middle, middle_val, it, 0)
        end
        
        if sign(middle_val) != sign(left_val) 
            b = middle
            right_val = middle_val
        else 
            a = middle
            left_val = middle_val
        end
    end

    inter = inter / 2
    middle = a + inter
    middle_val = f(middle)
    return (middle, middle_val, MAX_ITER, 0)
end

#=
Wyznacza rozwiązania równania f(x) = 0 metodą styczncyh
Zwraca czwórkę (r,v,it,err) 
r - przybliżenie rozwiązania, 
v - wartość f(r), 
it - liczba wykonanych iteracji, 
err - 1 gdy funkcja nie osiągnęła dokładności, 2 gdy pochodna jest bliska zera i 0 inaczej
=# 
function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    val = f(x0)
    if abs(val) < epsilon
        return (x0, val, 0, 0)
    end

    error_code = 0

    x = x0
    for it in 1:maxit
        d = pf(x)

        if abs(d) < epsilon
            error_code = 2
        end

        x_next = x - val / d
        val = f(x_next)
        if abs(x_next - x) < delta || abs(val) < epsilon
            return (x_next, val, it, error_code)
        end
        x = x_next
    end

    return (x, val, maxit, max(error_code, 1))
end

#=
Wyznacza rozwiązania równania f(x) = 0 metodą siecznych
Zwraca czwórkę (r,v,it,err)
r - przybliżenie rozwiązania, 
v - wartość f(r), 
it - liczba wykonanych iteracji, 
err - 1 gdy funkcja nie osiągnęła dokładności i 0 inaczej 
=#
function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    fa = f(x0)
    fb = f(x1)

    a = x0
    b = x1
    for it in 1:maxit
        if abs(fa) > abs(fb)
            (fa, fb) = (fb, fa)
            (a, b) = (b, a)
        end

        d = fa * (b - a) / (fb - fa)
        b = a
        fb = fa
        a = a - d
        fa = f(a)
        if abs(d) < delta || abs(fa) < epsilon
            return (a, fa, it, 0)
        end
    end

    return (a, fa, maxit, 1)
end

end
