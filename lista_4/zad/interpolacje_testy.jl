# Autor: Dawid Walczak
include("./interpolacje.jl")
using .Interpolacje
using Test

@testset begin
    @testset begin
        a = [1.0,1.0,1.0,1.0,1.0]

        f(x) = sum([a[i] * x^(i-1) for i in 1:length(a)])
        x = [i for i in range(-4.0,4.0,length(a))]

        fx = ilorazyRoznicowe(x, f.(x))
        b = naturalna(x,fx)
        @test a ≈ b
    end

    @testset begin
        a = [0.5,1.0,-3.0,1.0,10.0]

        f(x) = sum([a[i] * x^(i-1) for i in 1:length(a)])
        x = [i for i in range(-4.0,4.0,length(a))]

        fx = ilorazyRoznicowe(x, f.(x))
        b = naturalna(x,fx)
        @test a ≈ b
    end

    @testset begin
        δ = 1e-4
        for k in 1:100
            a = rand(15)
            f(x) = sum([a[i] * x^(i-1) for i in 1:length(a)])
            x = [i for i in range(-4.0,4.0,length(a))]

            fx = ilorazyRoznicowe(x, f.(x))
            b = naturalna(x,fx)
            for i in length(a)
                @test abs(a[i] - b[i]) < δ
            end
        end
    end
end