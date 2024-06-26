# Autor: Dawid Walczak

function calculate_max(T)
    my_max::T = 1.0
    while !isinf(my_max * T(2.0))       
        my_max *= T(2.0)
    end

    step = my_max / T(2.0)
    while !isinf(my_max + step)      
        my_max += step
        step /= T(2.0)
    end

    println("Dla $(T): max wyliczony przez nas $(my_max), rzeczywisty $(floatmax(T))")
    println("Czy równe? $(my_max == floatmax(T))")  
end

calculate_max(Float16)
calculate_max(Float32)
calculate_max(Float64)