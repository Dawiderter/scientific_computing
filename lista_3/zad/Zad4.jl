include("./SzukaczZer.jl")
using .SzukaczZer

f(x) = sin(x) - (x/2)^2
fp(x) = cos(x) - x/2

δ = 0.5e-5
ϵ = 0.5e-5

println("Metoda bisekcji")
println(mbisekcji(f, 1.5, 2.0, δ, ϵ))

println("Metoda stycznych")
println(mstycznych(f, fp, 1.5, δ, ϵ, 100))

println("Metoda siecznych")
println(msiecznych(f, 1.0, 2.0, δ, ϵ, 10))