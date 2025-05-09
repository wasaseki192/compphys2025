import Pkg
Pkg.activate(".")
using FastGaussQuadrature, LinearAlgebra
x,w = gausslegendre(10)
f(x) = (1-x^2)^(1/2)
println(dot(w,f.(x)))

