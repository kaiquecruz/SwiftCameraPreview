import UIKit
import AVFoundation

@objc(SwiftCameraPreview) class SwiftCameraPreview: CDVPlugin {

	var captureSession: AVCaptureSession?
	var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	var capturePhotoOutput: AVCaptureStillImageOutput?

    var photoOutput: UIImage!

    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    		let devices: NSArray = AVCaptureDevice.devices() as NSArray;
    		for de in devices {
    			let deviceConverted = de as! AVCaptureDevice
    			if(deviceConverted.position == position){
    				return deviceConverted
    		}
    	}
    	return nil
    }

    func showPreviewCamera(_ command: CDVInvokedUrlCommand) {

        let x = command.argument(at: 0) as? Int ?? 0
        let y = command.argument(at: 1) as? Int ?? 0
        let width = command.argument(at: 2) as? Int ?? 0
        let height = command.argument(at: 3) as? Int ?? 0
        let camera = command.argument(at: 4) as? String ?? "back"

	var captureDevice: AVCaptureDevice?
	if (camera == "back") {
		captureDevice = getDevice(position: AVCaptureDevice.Position.back)
        } else {
		captureDevice = getDevice(position: AVCaptureDevice.Position.front)
        }

	do {
		let input = try AVCaptureDeviceInput(device: captureDevice!)
           	captureSession = AVCaptureSession()
		captureSession?.addInput(input)

		videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
		videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
		videoPreviewLayer?.frame = CGRect(x: x, y: y, width: width, height: height)
		self.webView.layer.addSublayer(videoPreviewLayer!)

		capturePhotoOutput = AVCaptureStillImageOutput()
		captureSession?.addOutput(capturePhotoOutput!)

		captureSession?.startRunning()
		let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK")
		self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
	} catch {
		print(error)
		let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Showing Camera Preview failed.")
            	self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
	}
    }

    func takePicture(_ command: CDVInvokedUrlCommand) {
		
		let camera = command.argument(at: 0) as? String ?? "back"
		
		if let videoConnection = capturePhotoOutput?.connection(withMediaType: AVMediaTypeVideo) {
        	capturePhotoOutput?.captureStillImageAsynchronously(from: videoConnection) {
        		(imageDataSampleBuffer, error) -> Void in

                if let err = error {
                    print(err.localizedDescription)
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err.localizedDescription)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                	return
                }
				guard let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) else {
				    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Failed to create ImageData from AVCaptureSession")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
				    return
				}
                guard let tmp = UIImage(data: imageData) else {
                	let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Failed to create Image from ImageData")
                	self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                	return
                }
		
		if (camera == "back") {
			self.photoOutput = UIImage(cgImage: tmp.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
      		} else {
			self.photoOutput = UIImage(cgImage: tmp.cgImage!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
        	}

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK")
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        	}
        }
    }

    func showPicture(_ command: CDVInvokedUrlCommand) {
        let imageData: NSData = UIImageJPEGRepresentation(photoOutput, 1.0)! as NSData
        let strImage: String = imageData.base64EncodedString(options: .lineLength64Characters)

        captureSession?.stopRunning()
        videoPreviewLayer?.removeFromSuperlayer()

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: strImage)
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
	}

	func stopPreviewCamera(_ command: CDVInvokedUrlCommand) {
	    captureSession?.stopRunning()
	    videoPreviewLayer?.removeFromSuperlayer()
	}

}
