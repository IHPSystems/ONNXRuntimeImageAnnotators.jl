using Test

@testset "ONNXRuntimeImageAnnotators" begin
    include("onnx_models.jl")
    include("annotate_tests.jl")
end
