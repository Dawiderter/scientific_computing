# Dawid Walczak

function experiment(T)
    x = [T(2.718281828), T(-3.141592654), T(1.414213562), T(0.577215664), T(0.301029995)]
    y = [T(1486.2497), T(878366.9879), T(-22.37492), T(4773714.647), T(0.000185049)]
    m = x .* y
    
    forward = m[1] + m[2] + m[3] + m[4] + m[5]
    backward = m[5] + m[4] + m[3] + m[2] + m[1]
    great_to_low = (m[4] + m[1] + m[5]) + (m[2] + m[3])
    low_to_great = (m[5] + m[1] + m[4]) + (m[3] + m[2])
    
    d = -1.00657107000000e-11
    
    println("m = $(m)")

    println("Dla $(T)")
    println("Do przodu $(forward) błąd $(abs(forward - d)/abs(d))")
    println("Do tyłu $(backward) błąd $(abs(backward - d)/abs(d))")
    println("Najw do najmn $(great_to_low) błąd $(abs(great_to_low - d)/abs(d))")
    println("Najmn do najw $(low_to_great) błąd $(abs(low_to_great - d)/abs(d))")
    println("Prawdziwy $(d)")
end

experiment(Float32)
experiment(Float64)