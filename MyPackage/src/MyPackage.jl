module MyPackage

import LinearAlgebra
#import Revise
#import Random

greet() = print("Hello World!")

function mydot(x, y)
	return LinearAlgebra.dot(x, y)
end

#function myiseven(x::Int)
#	return x % 2 == 0
#end

end # module MyPackage
