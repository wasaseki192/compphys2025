import Pkg
Pkg.activate(".")
using QuadGK
println(quadgk(x -> (1-x^2)^(1/2), -1, 1)[1])

