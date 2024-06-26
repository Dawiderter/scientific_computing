# Autor: Dawid Walczak

f(x) = √(x^2 + 1) - 1
g(x) = x^2/(√(x^2 + 1) + 1)

n = 50
for i in 1:n
    x = 8.0^(-i)
    println("x = $(x), f(x) = $(f(x)), g(x) = $(g(x))")
end