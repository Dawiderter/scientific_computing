# Dawid Walczak

function p_exp(p_0, r, n)
    p_next(p_n) = p_n + r*p_n*(1-p_n)

    p = p_0
    res = [p]
    for i in 1:n
        p = p_next(p)
        push!(res, p)
    end
    return res
end

function p_exp32(p_0, r, n)
    p_0 = Float32(p_0)
    r = Float32(r)
    p_next(p_n) = p_n + r*p_n*(Float32(1)-p_n)

    p = p_0
    res = [p]
    for i in 1:n
        p = p_next(p)
        push!(res, p)
    end
    return res
end

function p_exp32_nudged(p_0, r, n)
    p_0 = Float32(p_0)
    r = Float32(r)
    p_next(p_n) = p_n + r*p_n*(Float32(1)-p_n)

    p = p_0
    res = [p]
    for i in 1:9
        p = p_next(p)
        push!(res, p)
    end
    p = p_next(p)
    p = trunc(p, digits=3)
    push!(res, p)
    for i in 1:(n-10)
        p = p_next(p)
        push!(res, p)
    end
    return res
end

r = p_exp(0.01, 3, 40)
r_n = p_exp32_nudged(0.01, 3, 40)
r_32 = p_exp32(0.01, 3, 40)

for i in 0:40
    println("i: $(i), f64: $(r[i + 1]), f32_δ: $(r_n[i + 1]), f32: $(r_32[i + 1])")
end