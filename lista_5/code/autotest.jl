# Autor: Dawid Walczak
# Moduł testujący blocksys

include("blocksys.jl")

using .blocksys

DANE = "../Dane"

function read_dane()
    list = []
    d = readdir(DANE)
    for d_i in d
        push!(list, ("$DANE/$(d_i)/A.txt", "$DANE/$(d_i)/b.txt"))
    end
    return list
end

using Test

@testset "Gauss Elimination" begin
    l = read_dane()
    for (a,b) in l
        a = FastAdaptedMatrix(a)
        b = Vector(b)
        x_true = ones(a.n)
        x = gaussElimination!(a,b)
        @test x ≈ x_true
    end
end

@testset "Pivoted Gauss Elimination" begin
    l = read_dane()
    for (a,b) in l
        a = FastAdaptedMatrix(a)
        b = Vector(b)
        x_true = ones(a.n)
        x = pivotedGaussElimination!(a,b)
        @test x ≈ x_true
    end
end

@testset "LU Decomposition" begin
    l = read_dane()
    for (a,b) in l
        a = FastAdaptedMatrix(a)
        b = Vector(b)
        x_true = ones(a.n)
        a = LU!(a)
        x = LUxb!(a,b)
        @test x ≈ x_true
    end
end

@testset "Pivoted LU Decomposition" begin
    l = read_dane()
    for (a,b) in l
        a = FastAdaptedMatrix(a)
        b = Vector(b)
        x_true = ones(a.n)
        a,p = pivotedLU!(a)
        x = pivotedLUxb!(a,p,b)
        @test x ≈ x_true
    end
end