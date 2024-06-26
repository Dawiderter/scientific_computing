# Autor: Dawid Walczak

function calculate_eta(T)
    my_eta::T = 1.0
    while (my_eta / T(2.0)) > T(0.0) 
        my_eta /= T(2.0)
    end
    println("Dla $(T): eta wyliczona przez nas $(my_eta), rzeczywisty $(nextfloat(T(0.0)))")
    println("Czy równe? $(my_eta == nextfloat(T(0.0)))") 
end

calculate_eta(Float16)
calculate_eta(Float32)
calculate_eta(Float64)