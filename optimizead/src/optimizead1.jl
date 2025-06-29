using Optim

# 最小化したい関数
f(x::Array{Float64}) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# 初期値
initial_x = [0.0, 0.0]

# 数値微分（差分法）で勾配を計算
function g!(G::Array{Float64}, x::Array{Float64})
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
end

# 最適化問題を解く
result = optimize(f, g!, initial_x, LBFGS(), Optim.Options(show_trace=true))
println("The minimum is at: ", Optim.minimizer(result))
