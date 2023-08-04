# ONNXRuntimeImageAnnotators

[![Build Status](https://github.com/IHPSystems/ONNXRuntimeImageAnnotators.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/IHPSystems/ONNXRuntimeImageAnnotators.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/IHPSystems/ONNXRuntimeImageAnnotators.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/IHPSystems/ONNXRuntimeImageAnnotators.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

ONNXRuntimeImageAnnotators provides implementations of the [ImageAnnotations.jl](https://github.com/IHPSystems/ImageAnnotations.jl)
[AbstractImageAnnotator interface](https://github.com/IHPSystems/ImageAnnotations.jl/blob/master/src/abstract_image_annotator.jl) using [ONNXRunTime.jl](https://github.com/jw3126/ONNXRunTime.jl).

## Limitations

Support is currently limited to the [YOLOv7 models](https://github.com/WongKinYiu/yolov7/releases/tag/v0.1).

## Usage

Using the TestImages image `lighthouse`, bounding box annotations can be computed using a YOLOv7 model:
```julia
using DataDeps
using ImageAnnotations
using ImageTransformations
using ONNXRuntimeImageAnnotators
using TestImages

include(normpath(dirname(pathof(ONNXRuntimeImageAnnotators)), "..", "test", "onnx_models.jl"))

model_path = joinpath(datadep"WongKinYiu_yolov7_v0.1_yolov7-nms-640", "yolov7-nms-640.onnx")
model_metadata = Dict(:input_name => "images", :output_name => "output")
annotator = ONNXRuntimeObjectAnnotator{Int, Float32, BoundingBoxAnnotation{Int, Float32}}(model_path, model_metadata) # Create an ONNXRuntimeObjectAnnotator using Int label type, Float32 coordinate type, and corresponding BoundingBoxAnnotation type

lighthouse_image = testimage("lighthouse")
lighthouse_image_scaled = imresize(lighthouse_image, (640, 640))

annotations = annotate(lighthouse_image_scaled, annotator)
# 1-element Vector{BoundingBoxAnnotation{Int64, Float32}}:
#  BoundingBoxAnnotation{Int64, Float32}(GeometryBasics.HyperRectangle{2, Float32}(Float32[229.6118, 359.71802], Float32[8.796692, 21.370972]), ImageAnnotation{Int64}(0, 0.46368203f0, "ONNXRuntimeObjectAnnotator"))
```
