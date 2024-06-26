# Dawid Walczak

using Plots
using LaTeXStrings

function x_exp(c, x_0, n)
    x_next(x_n) = x_n*x_n + c
    
    x = x_0
    res = [x]
    for i in 1:n
        x = x_next(x)
        push!(res, x)
    end 

    return res
end

function plot_iterative(c, x_0, range_start, range_end)
    x = range(range_start,range_end,100)
    y = x .* x .+ c
    plt = plot(x,[x y], legend = false, lw = 1.5, title = latexstring("c = $(c), x_0 = $(x_0)"), dpi=200)
    
    r = x_exp(c,x_0,40)
    
    arrow_style = arrow(:closed, :head)
    GR.setarrowsize(0.8)
    
    for i in 1:40
        plot!(plt, [r[i], r[i]], [r[i], r[i+1]], 
            color = :black, ls = :dash, arrow = arrow_style, lw = 0.3, shape = :circle, ms = 1.5)
        plot!(plt, [r[i], r[i+1]], [r[i+1], r[i+1]], 
            color = :black, ls = :dash, arrow = arrow_style, lw = 0.3, shape = :circle, ms = 1.5)
    end

    display(plt)
end

data = [[-2,1],[-2,2],[-2,1.99999999999999],[-1,1],[-1,-1],[-1,0.75],[-1,0.25]]

for (c, x_0) in data
    r = x_exp(c,x_0,40)
    println("=========\nc = $(c), x_0 = $(x_0)")
    for i in 1:length(r)
        println("i = $(i-1), x_i = $(r[i])")
    end
end


