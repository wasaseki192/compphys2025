using Test
#import MyPackage: myiseven
#import QuadGK
import LinearAlgebra
import MyPackage: mydot

@testset "mydot" begin
	@test mydot([1,1],[1,1]) == 2
	@test mydot([1,3],[2,4]) == 14
	@test mydot([2,2],[3,5]) == 16
end

nothing #test実行時に大量のメッセージを表示させなくする
