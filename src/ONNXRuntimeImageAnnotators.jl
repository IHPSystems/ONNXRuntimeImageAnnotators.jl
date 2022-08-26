module ONNXRuntimeImageAnnotators

using ColorTypes
using FixedPointNumbers
using GeometryBasics
using ImageAnnotations
using ImageCore

import ImageAnnotations.AbstractObjectAnnotator # TODO export from ImageAnnotations

import ONNXRunTime as ORT

export ONNXRuntimeObjectAnnotator

struct ONNXRuntimeObjectAnnotator{L, T, A} <: AbstractObjectAnnotator{L, T, A}
    model::ORT.InferenceSession
    model_metadata::Dict{Symbol, String}
end

function ONNXRuntimeObjectAnnotator{L, T, A}(model_path::String, model_metadata::Dict{Symbol, String}) where {L, T, A}
    model = ORT.load_inference(model_path)
    return ONNXRuntimeObjectAnnotator{L, T, A}(model, model_metadata)
end

function ImageAnnotations.annotate(
    image::AbstractArray{RGB{N0f8}, 2}, annotator::ONNXRuntimeObjectAnnotator{L, T, A}
)::Vector{A} where {L, T, A}
    image_float = RGB{Float32}.(image)
    return annotate(image_float, annotator)
end

function ImageAnnotations.annotate(
    image::AbstractArray{RGB{Float32}, 2}, annotator::ONNXRuntimeObjectAnnotator{L, T, A}
)::Vector{A} where {L, T, A <: BoundingBoxAnnotation}
    image_raw = rawview(channelview(image))
    images_raw = reshape(image_raw, 1, size(image_raw)...)
    input = Dict(annotator.model_metadata[:input_name] => images_raw)
    output = annotator.model(input)
    output_array = output[annotator.model_metadata[:output_name]]
    annotations = A[]
    for d in eachrow(output_array)
        top_left = Point2{T}(d[2], d[3])
        bottom_right = Point2{T}(d[4], d[5])
        label = L(d[1])
        confidence = d[7]
        annotator_name = String(nameof(ONNXRuntimeObjectAnnotator))
        annotation = BoundingBoxAnnotation(top_left, bottom_right, label; confidence, annotator_name)
        push!(annotations, annotation)
    end
    return annotations
end

end # module
