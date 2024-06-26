# Autor: Dawid Walczak
# Program testujący algorytmy znajdujące się w module blocksys
# Użycie:
# julia manualtest.jl 
#   <input_a> 
#   <output_x | - > 
#   <input_b | - > 
#   <lu | - > 
#   <p | - >

include("blocksys.jl")

using .blocksys

a_path = ARGS[1]
x_path = ARGS[2]
b_path = ARGS[3]
lu = ARGS[4] 
pivot = ARGS[5]

println("Czytanie macierzy testowej")
a = @time FastAdaptedMatrix(a_path)

if b_path == "-"
    println("Generowanie wektora prawych stron")
    x_true = ones(a.n)
    b = @time (a * x_true)
else 
    println("Czytanie wektora testowego")
    b = @time Vector(b_path)
    x_true = missing
end

println("Rozwiązywanie równania")
if lu == "lu"
    if pivot == "-" 
        a = @time LU!(a)
        x = @time LUxb!(a,b)
    elseif pivot == "p"
        a,p = @time pivotedLU!(a)
        x = @time pivotedLUxb!(a,p,b)
    else 
        throw("Zły argument pivota (-/p)")
    end
elseif lu == "-"
    if pivot == "-" 
        x = @time gaussElimination!(a,b)
    elseif pivot == "p"
        x = @time pivotedGaussElimination!(a,b)
    else 
        throw("Zły argument pivota (-/p)")
    end
else 
    throw("Zły argument lu (-/lu)")
end

println("Zapisywanie wyniku")
if ismissing(x_true)
    err = nothing
else 
    import LinearAlgebra.norm
    err = norm(x - x_true) / norm(x_true)
    println("Error: $err")
end
if x_path != "-"
    save(x_path,x,err)
end