using Zygote
using Optim

# 最小化したい関数 (xの型指定をしていない！)
f(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# 数値微分（差分法）で勾配を計算
function g(x::Array{Float64})
    G = similar(x)
    h = 1e-8
    for i in 1:length(x)
        tmp = x[i]
        x[i] = tmp + h
        f1 = f(x)
        x[i] = tmp - h
        f2 = f(x)
        G[i] = (f1 - f2) / (2h)
        x[i] = tmp
    end
    return G
end

# 初期値
initial_x = [0.0, 0.0]

# 差分公式
println(g(initial_x))

# 自動微分
g_zygote = x -> gradient(f,x)[1]
println(g_zygote(initial_x))
