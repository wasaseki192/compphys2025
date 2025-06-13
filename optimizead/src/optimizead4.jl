using Zygote

# 最小化したい関数 (xの型指定をしていない！)
f(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# 初期値
initial_x = [0.0, 0.0]

println(gradient(f, initial_x))
