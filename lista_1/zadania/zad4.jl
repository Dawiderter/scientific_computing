# Autor: Dawid Walczak

x = 1.0
i = 0

while x * (1.0 / x) == 1.0
    global x += 2^(-52)
    global i += 1
end

println("Znaleziono $(x), to $(i) liczba z kolei")