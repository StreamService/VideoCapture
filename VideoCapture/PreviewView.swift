//
//  PreviewView.swift
//  VideoCapture
//
//  Created by Jimmy Dee on 7/3/22.
//

import UIKit
import AVFoundation

enum CameraError: Error {
    case deviceUnavailable
    case setupFailed
}

class PreviewView: UIView {
    // Use AVCaptureVideoPreviewLayer as the view's backing layer.
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    // Connect the layer to a capture session.
    var session: AVCaptureSession? {
        get { previewLayer.session }
        set { previewLayer.session = newValue }
    }

    func setupSession() throws {
        let captureSession = AVCaptureSession()
        let videoOutput = AVCaptureVideoDataOutput()

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        // Connect the default video device (back camera)
        guard let defaultVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw CameraError.deviceUnavailable
        }

        let videoInput = try AVCaptureDeviceInput(device: defaultVideoDevice)
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            throw CameraError.setupFailed
        }

        // Connect and configure capture output.
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            throw CameraError.setupFailed
        }

        // Session configured. Commit configuration.
        captureSession.commitConfiguration()

        print("Capture output video settings: \(String(describing: videoOutput.videoSettings))")
        print("Available codecs: \(videoOutput.availableVideoCodecTypes)")

        // Use the configured session with the AVCaptureVideoPreviewLayer
        session = captureSession
    }
}
