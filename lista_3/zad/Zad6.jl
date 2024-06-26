include("./SzukaczZer.jl")
using .SzukaczZer

δ = 1e-5
ϵ = 1e-5

println("F1 =========")

f1(x) = ℯ^(1 - x) - 1
f1p(x) = -ℯ^(1 - x)

println("\nMetoda bisekcji")

ranges = [[0.0, 3.0], [-10.0, 20.0], [-100.0,200.0], [-10e10, 20e10]]

for rang in ranges
    println("Range [$(rang[1]),$(rang[2])]")
    println(mbisekcji(f1,rang[1],rang[2],δ,ϵ))
end

println("\nMetoda stycznych")

starts = [-2.0, 0.0, 2.0, 4.0, 7.0, 8.0]

for start in starts
    println("Start $(start)")
    println(mstycznych(f1,f1p,start,δ,ϵ,500))
end

println("\nMetoda siecznych")

starts = [[-1.0, 0.0], [0.0, 0.5], [1.5,2.0], [3.0,5.0]]

for start in starts
    println("Starts $(start[1]), $(start[2])")
    println(msiecznych(f1,start[1],start[2],δ,ϵ,500))
end

println("\nF2 =========")

f2(x) = x * ℯ^(-x)
f2p(x) = (ℯ^(-x)) * (1 - x)

println("\nMetoda bisekcji")

ranges = [[-1.0, 2.0], [-10.0, 20.0], [-100.0,200.0]]

for rang in ranges
    println("Range [$(rang[1]),$(rang[2])]")
    println(mbisekcji(f2,rang[1],rang[2],δ,ϵ))
end

println("\nMetoda stycznych")

starts = [-1.0, 0.99, 1.0, 1.01, 1.5]

for start in starts
    println("Start $(start)")
    println(mstycznych(f2,f2p,start,δ,ϵ,500))
end

println("\nMetoda siecznych")

starts = [[-1.0, -0.5], [0.5, 1.0], [0.5, 2.0], [1.0, 2.0]]

for start in starts
    println("Starts $(start[1]), $(start[2])")
    println(msiecznych(f2,start[1],start[2],δ,ϵ,500))
end