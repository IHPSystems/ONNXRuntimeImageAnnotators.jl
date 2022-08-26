using DataDeps

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

register(
    DataDep(
        "WongKinYiu_yolov7_v0.1_yolov7-nms-640",
        "",
        "https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7-nms-640.onnx",
        "db605e553548408ba4bfb9db636e47551ac73bedd0c86537d0afc3590c64e85f",
    ),
)
