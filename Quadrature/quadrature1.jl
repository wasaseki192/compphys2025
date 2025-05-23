import Pkg
Pkg.activate(".")
using FastGaussQuadrature, LinearAlgebra
x,w = gausslegendre(10)
f(x) = (1-x^2)^(1/2)
println("INTEGRAL: ",dot(w,f.(x)))
println("ERROR: ",pi/2-dot(w,f.(x)))

