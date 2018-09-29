//
//  CameraController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/16/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let nextPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Next"), for: .normal)
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        return button
    }()
    
   
    @objc fileprivate func handleNextButton() {
        print("Dismiss the window")
        dismiss(animated: true, completion: nil)
    }
    
    
    let capturePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "tap").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCapturePhoto() {
        print("Capturing photo...")
        let settings = AVCapturePhotoSettings()
        #if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        view.addSubview(containerView)
        _ = containerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        containerView.previewImageView.image = previewImage
        
//
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        _ = previewImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//
//        print("Finish processing photo sample buffer...")
//
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCaptureSessions()
        view.addSubview(capturePhotoButton)
        _ = capturePhotoButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 35, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        capturePhotoButton.layer.cornerRadius = 80/2
        capturePhotoButton.clipsToBounds = true
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nextPhotoButton)
        _ = nextPhotoButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 50, heightConstant: 50)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    let output = AVCapturePhotoOutput()
    fileprivate func setUpCaptureSessions() {
        let captureSession = AVCaptureSession()
        //1. Set up inputs
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                 captureSession.addInput(input)
            }
        } catch let err {
            print("Could not set up the inputs", err)
        }
       
        //2. Set up outputs
       
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        //3. setupoutput Previews
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }
}
