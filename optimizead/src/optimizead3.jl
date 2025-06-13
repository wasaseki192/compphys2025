using Optim

# 最小化したい関数
f(x::Array{Float64}) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# 初期値
initial_x = [0.0, 0.0]

result = optimize(f, initial_x, LBFGS(), Optim.Options(show_trace=true), autodiff = :finite)
println("The minimum is at: ", Optim.minimizer(result))
