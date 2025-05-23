using QuadGK
println("INTEGRAL: ",quadgk(x -> (1-x^2)^(1/2),-1, 1)[1])
println("ERROR: ",pi/2-quadgk(x -> (1-x^2)^(1/2), -1, 1)[1])

