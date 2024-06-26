# Dawid Walczak
using LinearAlgebra
include("./hilb.jl")
include("./matcond.jl")

function calc_err(A, n)
    x = ones(n)
    b = A * x

    x_g = A \ b
    x_gerr = norm(x_g - x)/norm(x)

    x_i = inv(A) * b
    x_ierr = norm(x_i - x)/norm(x)

    return (x_gerr, x_ierr)
end

#Eksperyment dla macierzy hilberta

for n in 2:50
    A = hilb(n)
    (gerr, ierr) = calc_err(A, n)
    println("Hilb($(n)), rank $(rank(A)), cond $(cond(A)) gerr $(gerr), inverr $(ierr)")
end

#Eksperyment dla losowych macierzy

K = 1000

C = [1, 10, 1e3, 1e7, 1e12, 1e16]
N = [5,10,20]

for n in N
    for c in C
        gerrsum = 0
        ierrsum = 0
        ranksum = 0
        condsum = 0
        for _ in 1:K
            A = matcond(n, c)
            while det(A) == 0
                A = matcond(n, c)
            end
            (gerr, ierr) = calc_err(A, n)
            gerrsum += gerr
            ierrsum += ierr
            ranksum += rank(A)
            condsum += cond(A)
        end
        gerr = gerrsum / K
        ierr = ierrsum / K
        m_rank = ranksum / K
        m_cond = condsum / K 
        println("R($(n), $(c)), rank $(m_rank), cond $(m_cond) gerr $(gerr), inverr $(ierr)")
    end
end