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
    
    
    @IBOutlet weak var shutter: UIButton!
    
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
        
        //TODO: test remote call
        imageCognitive(image:selectedImage)
        
        
        

    }
    
    //Store the newItem into localstorage
    private func storeInfo(){
        
        var imageName:String = "\(self.wordFrom!)-\(self.wordTo!)-\(Date()).jpg"
        var newItem = Item(id: 0, date: Date(), image: imageName, wordFrom: self.wordFrom ?? "", wordTo: self.wordTo ?? "", soundFrom: "", soundTo: "")
        addItem(newItem)
        saveImageToSandBox(imageName,imageTook!)
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
    
    let progressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    
    func imageCognitive(image:UIImage){
                // URL for cognitive services tag API
                guard let url = URL(string: "https://image-cognitive.cognitiveservices.azure.com/vision/v2.1/analyze?visualFeatures=Categories,Description,Color") else { return }
        
                // API request
                let cognitivesServicesAPIKey = "b3363696b59440119742b10ae102a8a3"
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                request.setValue(cognitivesServicesAPIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
                request.httpBody = image.jpegData(compressionQuality: 1)
        
                var returnString:String = ""
        
                //Progress bar start
                shutter.isEnabled = false
                self.view.backgroundColor = UIColor.gray
                progressView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width-20, height: 30)
                progressView.layer.position = CGPoint(x: self.view.frame.width/2, y: 100)
                //let progressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
                progressView.center = self.view.center;
                progressView.progress = 0.1
                self.view.addSubview(progressView)
                progressView.setProgress(0.5, animated: true)
                progressView.progressTintColor = UIColor.orange//已有进度颜色
                progressView.trackTintColor = UIColor.black//剩余进度颜色
                progressView.observedProgress = Progress.current()
        
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, let response = response as? HTTPURLResponse else { return }
        
                    if response.statusCode == 200 {
                        //let responseString = String(data: data, encoding: .utf8)
                        let describeImage = try? JSONDecoder().decode(DescribeImage.self, from: data)
                        guard let tags = describeImage?.description?.tags else { return }
                        DispatchQueue.main.async {
                            if tags.count > 0 {
                                returnString = tags[0]
                                self.wordFrom = returnString
                                self.translate(returnString, "zh-Hans")
                            } else {
                                returnString =  "Azure doesn't know what it is,haha."
                                self.wordFrom = returnString
                                self.translate(returnString, "zh-Hans")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            returnString = "Azure doesn't know what it is,haha."
                            self.wordFrom = returnString
                            self.translate(returnString, "zh-Hans")
                        }
                    }
                }
                // Resume task
                task.resume()
    }
    
    
//    func parseJson(jsonData: Data) {
//
//        //*****TRANSLATION RETURNED DATA*****
//        struct ReturnedJson: Codable {
//            var translations: [TranslatedStrings]
//        }
//        struct TranslatedStrings: Codable {
//            var text: String
//            var to: String
//        }
//
//        let jsonDecoder = JSONDecoder()
//        //print(String(data: jsonData, encoding: .utf8))
//        let translateWord = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: jsonData)
//        //let translateWord = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: jsonData)
//        let translations = translateWord?[0].translations
//        print(translations)
//
//        //Put response on main thread to update UI
//        DispatchQueue.main.async {
//            self.wordTo = translations![0].text
//            self.wordTo="没找到合适的翻译"
//        }
//    }
    
    func translate(_ text: String, _ lang: String) {
        getToken("") { (data, response, error) in
            guard let data = data, let token = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else {return}

            msTranslate(token, translate: text, toLang: lang) { (data, response,error) in
                guard let data = data,
                    let result = try? extract(data) else {
                    return
                }
                self.wordTo = result
                self.storeInfo()
                DispatchQueue.main.sync {
                    self.performSegue(withIdentifier: "displayDetailSegue", sender: nil)
                }
                
            }
        }
    }
    
    private func getTranslate(_ wordFrom: String){
        
        //wordTo = "没找到合适的翻译"
        //translate(wordFrom, "ja")
        
        
        
        
//        let azureKey = "13d4e880fd4f4858b47e226d4fd5912b"
//        //let contentType = "application/json"
//        let traceID = "179543b0-5927-41ab-81e3-bfb537627499"
//        let host = "translate-fromto.cognitiveservices.azure.com"
//        let apiURL = "https://translate-fromto.cognitiveservices.azure.com/sts/v1.0/issuetoken?api-version=3.0&from=en&to=ja"
//
//        var wordFroms = [WordFrom]()
//        var wordFromInner = WordFrom()
//        wordFromInner.text = wordFrom
//        wordFroms.append(wordFromInner)
//
//        let jsonToTranslate = try? JSONEncoder().encode(wordFroms)
//        let url = URL(string: apiURL)
//        var request = URLRequest(url: url!)
//
//        request.httpMethod = "POST"
//        request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
//        request.addValue(host, forHTTPHeaderField: "Host")
//        request.addValue(String(describing: jsonToTranslate?.count), forHTTPHeaderField: "Content-Length")
//        request.httpBody = jsonToTranslate
//
//        let config = URLSessionConfiguration.default
//        let session =  URLSession(configuration: config)
//
//        let task = session.dataTask(with: request) { (responseData, response, responseError) in
//
//            if responseError != nil {
//                print("this is the error ", responseError!)
//
//                let alert = UIAlertController(title: "Could not connect to service", message: "Please check your network connection and try again", preferredStyle: .actionSheet)
//
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//                self.present(alert, animated: true)
//
//            }
//            print("*****")
//            self.parseJson(jsonData: responseData!)
//        }
//        task.resume()
        
        
        
//        //self.wordTo = "测试物体"
//
//        // URL for cognitive services tag API
//        guard let url = URL(string: "https://translate-fromto.cognitiveservices.azure.com/sts/v1.0/issuetoken/translate?api-version=1.0&to=ja") else { return }
//
//        // API request
//        let cognitivesServicesAPIKey = "13d4e880fd4f4858b47e226d4fd5912b"
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(cognitivesServicesAPIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//        request.httpBody = "{'Text':‘\(wordFrom)’}".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
//
//        var returnString:String = ""
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                let translateWord = try? JSONDecoder().decode(TranslateWord.self, from: data)
//                guard let translations = translateWord?.translations else { return }
//                DispatchQueue.main.async {
//                    if translations.count > 0 {
//                        returnString = translations[0].text!
//                        self.wordTo = returnString
//                        self.storeInfo()
//                        self.performSegue(withIdentifier: "displayDetailSegue", sender: nil)
//                    } else {
//                        returnString = "LiQi: 找不到合适的翻译"
//                        self.wordTo = returnString
//                        self.storeInfo()
//                        self.performSegue(withIdentifier: "displayDetailSegue", sender: nil)
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    returnString = "LiQi: 找不到合适的翻译"
//                    self.wordTo = returnString
//                    self.storeInfo()
//                    self.performSegue(withIdentifier: "displayDetailSegue", sender: nil)
//                }
//            }
//        }
//        // Resume task
//        task.resume()
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
