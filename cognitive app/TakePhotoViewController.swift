//
//  TakePhotoViewController.swift
//  cognitive app
//
//  Created by LiQi on 3/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import UIKit
import AVFoundation

class TakePhotoViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var backCamera:AVCaptureDevice?
    var frontCamera:AVCaptureDevice?
    var currentCamera:AVCaptureDevice?
    var photoOutput:AVCapturePhotoOutput?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var imageTook:UIImage?
    var wordFrom:String?
    var wordTo:String?
    
    
    
    @IBAction func takePhoto(_ sender: Any) {
        //get the photo
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // Retrieve tags
    //  https://westcentralus.api.cognitive.microsoft.com/vision
    //  Key 1: c447add6f4234b4abd9c6496dfb5c2b4
    //  Key 2: 4f4a5d702bf1401ba909d87f319bac20
    //  requirment:
    //      The image must be presented in JPEG, PNG, GIF, or BMP format
    //      The file size of the image must be less than 4 megabytes (MB)
    //      The dimensions of the image must be greater than 50 x 50 pixels
    //      For the Read API, the dimensions of the image must be between 50 x 50 and 10000 x 10000 pixels.
    //
    private func getTag(selectedImage: UIImage?) {
        guard let selectedImage = selectedImage else { return}
        
        wordFrom = "teststuff" //TODO:It needs to be getten from remote api calling
        wordTo = "测试物体" //TODO:It needs to be getten from remote api calling
        
        self.storeInfo()
        
        
        
        self.performSegue(withIdentifier: "displayDetailSegue", sender: nil)
        
//        // URL for cognitive services tag API
//        guard let url = URL(string: "https://unitec-computer-vision.cognitiveservices.azure.com/vision/v1.0/describe") else { return}
//
//        // API request
//        let cognitivesServicesAPIKey = "c447add6f4234b4abd9c6496dfb5c2b4"
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//        request.setValue(cognitivesServicesAPIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//        request.httpBody = selectedImage.jpegData(compressionQuality: 1)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
////                let responseString = String(data: data, encoding: .utf8)
//                let describeImage = try? JSONDecoder().decode(DescribeImage.self, from: data)
//                guard let captions = describeImage?.description?.captions else { return }
//                DispatchQueue.main.async {
//                    if captions.count > 0 {
//                        self.wordFrom = captions[0].text!
//                        self.wordTo = self.getTranslate(captions[0].text!)
//                    } else {
//                        self.wordFrom = "LiQi: No captions available"
//                        self.wordTo = self.getTranslate("LiQi: No captions available")
//                    }
//                    //
//                    self.storeInfo()
//                    //go to detail page
//                    self.performSegue(withIdentifier: "displayDetailSegue", sender: nil)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.wordFrom = "LiQi: No captions available"
//                    self.wordTo = self.getTranslate(error?.localizedDescription ?? "LiQi: Invalid response.")
//                    //
//                    self.storeInfo()
//                    //go to detail page
//                    self.performSegue(withIdentifier: "displayDetailSegue", sender: nil)
//                }
//            }
//        }
//
//
//
//        // Resume task
//        task.resume()
    }
    
    //Store the newItem into localstorage
    private func storeInfo(){
        
        var imageName:String = "\(self.wordFrom!)-\(self.wordTo!)-\(Date()).jpg"
        var newItem = Item(id: 0, date: Date(), image: imageName, wordFrom: self.wordFrom ?? "", wordTo: self.wordTo ?? "", soundFrom: "", soundTo: "")
        addItem(newItem)
        saveImageToSandBox(imageName,imageTook!)
    }
    
    //TODO: calling translate cognitive api
    private func getTranslate(_ wordFrom: String)->String {
            var wordTo = "临时翻译"
        
            return wordTo
        }

    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
            currentCamera = backCamera
        }
    }
    
    func setupInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session:captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at:0)
    }
    
    func setupRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //take a photo
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        setupRunningCaptureSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailSegueTo = segue.destination as? DetailViewController{
            //let index = (itemTableView.indexPathForSelectedRow?.row ?? 0) + 1
            detailSegueTo.itemID = itemList.count
            detailSegueTo.segueSource = "takephoto"
        }
    }

}


extension TakePhotoViewController:AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output:AVCapturePhotoOutput,didFinishProcessingPhoto photo:AVCapturePhoto, error:Error?){
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            imageTook = UIImage(data:imageData)
            getTag(selectedImage: imageTook)
        }
    }
}
