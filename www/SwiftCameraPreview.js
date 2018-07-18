var SwiftCameraPreview = {

    showPreviewCamera: function(success, error, arg0, arg1, arg2, arg3, arg4) {
        cordova.exec(success, error, "SwiftCameraPreview", "showPreviewCamera", [arg0, arg1, arg2, arg3, arg4]);
    },

    takePicture: function(success, error) {
        cordova.exec(success, error, "SwiftCameraPreview", "takePicture", []);
    },

    showPicture: function(success, error) {
        cordova.exec(success, error, "SwiftCameraPreview", "showPicture", []);
    },

    stopPreviewCamera: function(success, error) {
        cordova.exec(success, error, "SwiftCameraPreview", "stopPreviewCamera", []);
    }
};

module.exports = SwiftCameraPreview;