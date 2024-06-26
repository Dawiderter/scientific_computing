# Autor: Dawid Walczak

module Interpolacje

export ilorazyRoznicowe,warNewton,naturalna,rysujNnfx

# Zwraca wektor zawierający obliczone ilorazy różnicowe na podstawie podanych węzłów x i ich wartości f
# Metoda 
# f[x1] ----------> f[x1] ----------> f[x1] ----------> f[x1]
#       ↘
# f[x2] -------> f[x1,x2] -------> f[x1,x2] -------> f[x1,x2] 
#       ↘                 ↘
# f[x3] -------> f[x2,x3] ----> f[x1,x2,x3] ----> f[x1,x2,x3] 
#       ↘                 ↘                 ↘ 
# f[x4] -------> f[x3,x4] ----> f[x2,x3,x4] -> f[x1,x2,x3,x4]  
# Ostatnia kolumna jest naszym wynikiem
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    fx = copy(f)
    n = length(x)

    for i in 2:n
        for j in reverse(i:n)
            fx[j] = (fx[j] - fx[j - 1])/(x[j] - x[j - i + 1])
        end
    end

    return fx
end

# Zwraca wartość wielomianu w postaci Newtona o węzłach x i współczynnikach fx w danym punkcie t
function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    n = length(fx)
    w = 0
    for i in reverse(1:n)
        w = fx[i] + w * (t - x[i])
    end
    return w
end

# Zamienia wielomian w postaci Newtona w węzłach x i współczynnikach fx na wektor współczynników tego wielomianu w postaci naturalnej
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    n = length(x) - 1

    b = zeros(n + 1)
    b[1] = fx[n + 1]

    for i in reverse(0:(n-1))
        b[n-i+1] = b[n-i]
        for j in reverse(1:(n-i-1))
            b[j+1] = b[j] - b[j+1]*x[i+1]
        end
        b[1] = fx[i+1] - b[1]*x[i+1]
    end

    return b
end

using Plots
# Rysuje zadaną funkcję i jej wielomian interpolacyjny stopnia n (o równoodległych węzłach) na przedziale [a,b]
function rysujNnfx(f,a::Float64,b::Float64,n::Int)
    x = [xi for xi in range(a,b, n + 1)]
    fx = ilorazyRoznicowe(x, f.(x))

    xd = range(a,b,200)
    fd = [f(t) for t in xd]
    pd = [warNewton(x, fx, t) for t in xd]
    plt = plot(xd, [fd pd], labels = ["Funkcja" "Interpolacja"])
    return plt
end

end
