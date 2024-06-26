# Autor: Dawid Walczak
include("./interpolacje.jl")
using .Interpolacje

g(x) = sin(x) * x^2
for i in [5,10,15]
    plt = rysujNnfx(g, -1.0, 1.0, i)
    savefig(plt, "./plots/sinx_$(i).svg")
end

g(x) = ℯ^x
for i in [5,10,15]
    plt = rysujNnfx(g, 0.0, 1.0, i)
    savefig(plt, "./plots/ex_$(i).svg")
end