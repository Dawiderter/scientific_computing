include("./SzukaczZer.jl")
using .SzukaczZer

using Test

# Testowanie metody bisekcji
@testset begin
    @testset begin
        f(x) = x
        a = Float64(-ℯ)
        b = Float64(π)
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mbisekcji(f,a,b,δ,ϵ)
        @test err == 0
        @test (abs(r - 0.0) < δ || abs(v) < ϵ) 
    end
    
    @testset begin
        f(x) = ℯ^x - ℯ
        a = Float64(-ℯ)
        b = Float64(π)
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mbisekcji(f,a,b,δ,ϵ)
        @test err == 0
        @test (abs(r - 1.0) < δ || abs(v) < ϵ) 
    end
    
    @testset begin
        f(x) = x*(x-1)^2 - 2
        a = -100.0
        b = 100.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mbisekcji(f,a,b,δ,ϵ)
        @test err == 0
        @test (abs(r - 2.0) < δ || abs(v) < ϵ) 
    end
    
    @testset begin
        f(x) = x
        a = 1.0
        b = 2.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mbisekcji(f,a,b,δ,ϵ)
        @test err == 1
    end
end

# Testowanie metody stycznych (Newtona)
@testset begin
    @testset begin
        f(x) = x^2
        fp(x) = 2x
        x_0 = 2.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mstycznych(f,fp,x_0,δ,ϵ,10)
        @test err == 0
        @test (abs(r - 0.0) < δ || abs(v) < ϵ) 
    end
    
    @testset begin
        f(x) = ℯ^x - ℯ
        fp(x) = ℯ^x
        x_0 = 0.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mstycznych(f,fp,x_0,δ,ϵ,10)
        @test err == 0
        @test (abs(r - 1.0) < δ || abs(v) < ϵ)
    end

    @testset begin
        f(x) = x*ℯ^(-x)
        fp(x) = (1-x)*(ℯ^(-x))
        x_0 = -1.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mstycznych(f,fp,x_0,δ,ϵ,10)
        @test err == 0
        @test (abs(r - 0.0) < δ || abs(v) < ϵ)
    end

    @testset begin
        f(x) = x^3 - 2x + 2
        fp(x) = 3x^2 - 2
        x_0 = 0.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mstycznych(f,fp,x_0,δ,ϵ,100)
        @test err == 1
    end

    @testset begin
        f(x) = x*ℯ^(-x)
        fp(x) = (1-x)*(ℯ^(-x))
        x_0 = 1.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = mstycznych(f,fp,x_0,δ,ϵ,100)
        @test err == 2
    end
end

# Testowanie metody siecznych
@testset begin
    @testset begin
        f(x) = x^2
        x_0 = 2.0
        x_1 = 1.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = msiecznych(f,x_0,x_1,δ,ϵ,20)
        @test err == 0
        @test (abs(r - 0.0) < δ || abs(v) < ϵ) 
    end
    
    @testset begin
        f(x) = ℯ^x - ℯ
        fp(x) = ℯ^x
        x_0 = -1.0
        x_1 = 0.0
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = msiecznych(f,x_0,x_1,δ,ϵ,20)
        @test err == 0
        @test (abs(r - 1.0) < δ || abs(v) < ϵ) 
    end
    
    @testset begin
        f(x) = x*(x-1)^2 - 2
        fp(x) = 3x^2 - 4x + 1
        x_0 = 1.0
        x_1 = 1.5
        δ = 1e-5
        ϵ = 1e-5
    
        r,v,it,err = msiecznych(f,x_0,x_1,δ,ϵ,20)
        @test err == 0
        @test (abs(r - 2.0) < δ || abs(v) < ϵ) 
    end
end