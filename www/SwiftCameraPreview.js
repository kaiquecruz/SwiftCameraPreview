var SwiftCameraPreview = {

    showPreviewCamera: function(success, error, arg0, arg1, arg2, arg3, arg4, arg5) {
        cordova.exec(success, error, "SwiftCameraPreview", "showPreviewCamera", [arg0, arg1, arg2, arg3, arg4, arg5]);
    },

    takePicture: function(success, error, arg0) {
        cordova.exec(success, error, "SwiftCameraPreview", "takePicture", [arg0]);
    },

    showPicture: function(success, error) {
        cordova.exec(success, error, "SwiftCameraPreview", "showPicture", []);
    },

    stopPreviewCamera: function(success, error) {
        cordova.exec(success, error, "SwiftCameraPreview", "stopPreviewCamera", []);
    }
};

module.exports = SwiftCameraPreview;
