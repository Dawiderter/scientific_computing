# Autor: Dawid Walczak

exact = cos(1) - 3sin(3)

approx(f,x,h) = (f(x + h) - f(x))/h 

f(x) = sin(x) + cos(3x)

for n in 0:54
    h = 2.0^(-n)
    a_d = approx(f, 1.0, h)
    dif = abs(exact - a_d)
    println("n: $(n), wartość: $(a_d), błąd: $(dif)")
end

println("dokładna wartość: $(exact)")