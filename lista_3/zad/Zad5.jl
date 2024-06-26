include("./SzukaczZer.jl")
using .SzukaczZer

f(x) = 3x - ℯ^x
δ = 1e-4
ϵ = 1e-4

ranges = [[0.0, 1.0], [1.0, 2.0]]

for rang in ranges
    println("Range [$(rang[1]),$(rang[2])]")
    println(mbisekcji(f,rang[1],rang[2],δ,ϵ))
end
