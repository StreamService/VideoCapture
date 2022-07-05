//
//  ViewController.swift
//  VideoCapture
//
//  Created by Jimmy Dee on 7/3/22.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let previewView = PreviewView()

        do {
            try previewView.setupSession()
            // Video fills the view
            previewView.previewLayer.videoGravity = .resizeAspectFill
        }
        catch let error {
            switch error {
            case CameraError.deviceUnavailable:
                fatalError("Couldn't find default video device")
            case CameraError.setupFailed:
                fatalError("Failed to set up video capture session")
            default:
                // Can also be an exception from AVCaptureDeviceInput
                fatalError("Unknown error setting up PreviewView: \(String(describing: error))")
            }
        }

        view.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false

        // constrain the PreviewView to fill its superview
        view.addConstraint(previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        view.addConstraint(previewView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        view.addConstraint(previewView.widthAnchor.constraint(equalTo: view.widthAnchor))
        view.addConstraint(previewView.heightAnchor.constraint(equalTo: view.heightAnchor))

        // https://developer.apple.com/documentation/avfoundation/avcapturesession
        // "The startRunning() method is a blocking call which can take some time, therefore start the session on a serial dispatch queue so that you don’t block the main queue."
        DispatchQueue.main.async {
            previewView.session?.startRunning()
        }
    }
}

