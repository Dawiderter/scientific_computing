# Autor: Dawid Walczak
include("./interpolacje.jl")
using .Interpolacje

g(x) = abs(x)
for i in [5,10,15]
    plt = rysujNnfx(g, -1.0, 1.0, i)
    savefig(plt, "./plots/absx_$(i).svg")
end

g(x) = 1.0/(1.0 + x^2)
for i in [5,10,15]
    plt = rysujNnfx(g, -5.0, 5.0, i)
    savefig(plt, "./plots/1x2_$(i).svg")
end