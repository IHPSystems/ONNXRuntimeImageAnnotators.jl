using DataDeps
using ImageAnnotations
using ImageTransformations
using ONNXRuntimeImageAnnotators
using Test
using TestImages

@testset "Annotation" begin
    lighthouse_image = testimage("lighthouse")

    @testset "yolov7" begin
        model_path = joinpath(datadep"WongKinYiu_yolov7_v0.1_yolov7-nms-640", "yolov7-nms-640.onnx")
        model_metadata = Dict(:input_name => "images", :output_name => "output")
        annotator = ONNXRuntimeObjectAnnotator{Int, Float32, BoundingBoxAnnotation{Int, Float32}}(model_path, model_metadata)
        lighthouse_image_scaled = imresize(lighthouse_image, (640, 640))
        annotations = annotate(lighthouse_image_scaled, annotator)

        @test length(annotations) > 0
    end
end
