# Autor: Dawid Walczak

function calculate_macheps(T) :T
    my_eps::T = 1.0
    while (T(1.0) + my_eps / T(2.0)) > T(1.0) 
        my_eps /= T(2.0)
    end
    println("Dla $(T): macheps wyliczony przez nas $(my_eps), rzeczywisty $(eps(T))")
    println("Czy równe? $(my_eps == eps(T))") 
end

calculate_macheps(Float16)
calculate_macheps(Float32)
calculate_macheps(Float64)