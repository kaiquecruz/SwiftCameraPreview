# SwiftCameraPreview

== Usage ==

CameraToUse: "back" | "front"

EncodedImg: base64EncodedString Image, decode with: "data:image/jpeg;base64," + EncodedImg;

- SwiftCameraPreview.showPreviewCamera(function s(msg){}, function e(msg){}, anchorX, anchorY, anchorZ, width, height, CameraToUse);

- SwiftCameraPreview.takePicture(function s(msg){}, function e(msg){}, CameraToUse);

- SwiftCameraPreview.showPicture(function s(EncodedImg){}, function e(msg){});

- SwiftCameraPreview.stopPreviewCamera(function s(msg){}, function e(msg){});
