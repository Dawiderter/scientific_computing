# Autor: Dawid Walczak

include("matrixgen.jl")
using .matrixgen

include("blocksys.jl")
using .blocksys

function testgen(n::Int, l::Int, ck::Float64, outputdir::String)
    mkdir(outputdir)
    blockmat(n,l,ck,"$outputdir/A.txt")
    a = FastAdaptedMatrix("$outputdir/A.txt")
    x_true = ones(a.n)
    b = a * x_true
    open("$outputdir/b.txt", "w") do file
        println(file, a.n)
        for b_i in b
            println(file, b_i)
        end
    end
end