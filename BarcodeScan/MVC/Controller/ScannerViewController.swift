 //
 //  ViewController.swift
 //  BarcodeScanner
 //
 //  Created by Mikheil Gotiashvili on 7/14/17.
 //  Copyright © 2017 Mikheil Gotiashvili. All rights reserved.
 //
 
 import UIKit
 import AVFoundation
 import AudioToolbox
 
 import SwiftyJSON
 class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //, AVCaptureVideoDataOutputSampleBufferDelegate
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    
    var aImage: UIImage!
    
    
    var flag : Bool = false
    var imatch: CIImage!
    var imgleft = UIImageView()
    var lblleft = UILabel()
    
    private var rect: CIQRCodeFeature = CIQRCodeFeature()
    var objBarcodeData = BarcodeData()
    private let ciContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = "Scanner"
        view.backgroundColor = .white
        self.refreshdata()
        
        view.addSubview(codeLabel)
        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        self.imgleft = UIImageView(frame: CGRect(x: 0, y: 0, width: 2, height: self.view.bounds.height))
        self.imgleft.image = #imageLiteral(resourceName: "line_vertical")
        self.imgleft.contentMode = .scaleAspectFit
       
        self.lblleft = UILabel(frame: CGRect(x: 0, y: 0, width: 2, height: self.view.bounds.height))
        self.lblleft.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.6745098039, blue: 0.3960784314, alpha: 1)
        
        view.addSubview(self.lblleft)
        viewanimationlefttoright()
      
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    func viewanimation(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear, .curveEaseInOut], animations: { [weak self] in
            self?.codeLabel.center.y = (self?.view.bounds.height)! - 2
            }, completion: { (_) in
                
                UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut],
                               animations: {
                                self.codeLabel.center.y -= self.view.bounds.height - 64
                                self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.viewanimation()
                })
                
        })
    }
    func viewanimationlefttoright(){
        
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear, .curveEaseInOut], animations: { [weak self] in
            self?.lblleft.center.x = (self?.view.bounds.width)! - 2
            }, completion: { (_) in
                
                UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut],
                               animations: {
                                self.lblleft.center.x -= self.view.bounds.width - 2
                                self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.viewanimationlefttoright()
                })
                
        })
    }
    func stopanimation(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.1)
        UIView.setAnimationCurve(.linear)
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    //MARK:- Skip Tap
    
    func refreshdata(){
        captureDevice = AVCaptureDevice.default(for: .video)
        if let captureDevice = captureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                //captureSession?.sessionPreset = AVCaptureSession.Preset.low
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.upce, .code128, .qr, .ean13,  .ean8, .code39, .code39Mod43, .code93, .aztec, .pdf417, .itf14, .dataMatrix, .interleaved2of5] //AVMetadataObject.ObjectType
                captureSession.startRunning()
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
            } catch {
                print("Error Device Input")
            }
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            codeFrame.frame = CGRect.zero
            codeLabel.text = "No Data"
            return
        }
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let stringCodeValue = metadataObject.stringValue else { return }
        view.addSubview(codeFrame)
        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds
        codeLabel.text = stringCodeValue
        stopanimation()
        captureSession?.stopRunning()
        captureSession = nil
        videoDataOutput = nil
        videoPreviewLayer = nil
        LicenseParser(message: stringCodeValue)
    }
    func LicenseParser(message : String){
        var arrFixedData = ["DCS", "DCT", "DCU", "DAG", "DAI", "DAJ", "DAK", "DCG", "DAQ", "DCA", "DCB", "DCD", "DCF", "DCH", "DBA", "DBB", "DBC", "DBD", "DAU", "DCE", "DAY", "ZWA", "ZWB", "ZWC", "ZWD", "ZWE", "ZWF","DAC","DAD"]
        var arrDriverData = ["Customer Family Name", "Customer Given Name", "Name Suffix", "Street Address 1", "City", "State Code", "Postal Code", "Country Identification", "License Number", "Class", "Restrictions", "Endorsements", "Document Discriminator", "Vehicle Code", "Expiration Date", "Date Of Birth", "Sex", "Issue Date", "Height", "Weight", "Eye Color", "Control Number", "Endorsements", "Transaction Types", "Under 18 Until", "Under 21 Until", "Revision Date","First Name","Middle Name"]
        var dict: [String : String] = [:]
        
        for i in 0..<arrFixedData.count {
            
            let range = NSString(string: message).range(of: arrFixedData[i], options: String.CompareOptions.caseInsensitive)
            
            if Int(range.location) != NSNotFound {
                
                var temp = (message as? NSString)?.substring(from: range.location + range.length)
                let end: NSRange? = (temp as NSString?)?.range(of: "\n")
                if Int(end?.location ?? 0) != NSNotFound {
                    temp = (temp as NSString?)?.substring(to: (end?.location)!)
                    temp = temp?.replacingOccurrences(of: "\n", with: "")
                    temp = temp?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }
                dict[arrDriverData[i]] = temp
            }
        }
        // print(dict)
        NextView(dict: dict)
    }
    func NextView(dict : [String : String]){
        if self.flag == false{
            if dict.count > 0{
                var strfirstname = ""
                if let val = dict["First Name"] {
                    strfirstname = val
                }else if let val = dict["Customer Given Name"]{
                    strfirstname = val
                }
                let dict1 : [String : JSON] = ["Firstname" : JSON(strfirstname as Any),"Middlename" : JSON(dict["Middle Name"] as Any),"Lastname" : JSON(dict["Customer Family Name"] as Any),"DOB" : JSON(dict["Date Of Birth"] as Any),"Issuedate" : JSON(dict["Issue Date"] as Any),"Expiry" : JSON(dict["Expiration Date"] as Any),"License" : JSON(dict["License Number"] as Any),"Country" : JSON(dict["Country Identification"] as Any),"Street" : JSON(dict["Street Address 1"] as Any),"City" : JSON(dict["City"] as Any),"StateCode" : JSON(dict["State Code"] as Any),"PostalCode" : JSON(dict["Postal Code"] as Any)]
                self.objBarcodeData = BarcodeData(json: dict1)
                arrbarcodedetail.append(self.objBarcodeData.Firstname + " " + self.objBarcodeData.Middlename + " " + self.objBarcodeData.Lastname)
                let strBirthdate = setdatefromstring(strdate: self.objBarcodeData.DOB)
                arrbarcodedetail.append(strBirthdate)
                let strissuingDate = setdatefromstring(strdate: self.objBarcodeData.Issuedate)
                arrbarcodedetail.append(strissuingDate)
                let strexpiryDate = setdatefromstring(strdate: self.objBarcodeData.Expiry)
                arrbarcodedetail.append(strexpiryDate)
                arrbarcodedetail.append(self.objBarcodeData.Country)
                arrbarcodedetail.append(self.objBarcodeData.License)
                let strAdd = self.objBarcodeData.Street + " " + self.objBarcodeData.City + " " + self.objBarcodeData.StateCode
                arrbarcodedetail.append(strAdd + " " + self.objBarcodeData.PostalCode)
                let add1 = self.objBarcodeData.Street + " " + self.objBarcodeData.City
                let add2 = self.objBarcodeData.StateCode + " " + self.objBarcodeData.PostalCode
                
                //Fill Data
                dictQRdetail = ["FN" : self.objBarcodeData.Firstname , "LN" : self.objBarcodeData.Lastname , "DL" : self.objBarcodeData.License, "EXP" : self.objBarcodeData.Expiry, "ADD1" : add1 , "ADD2" : add2 , "DOB" : strBirthdate , "ISS" : strissuingDate , "COUNTRY" : self.objBarcodeData.Country]
                
            }
            self.flag = true
            DispatchQueue.main.async {
                if arrbarcodedetail.count > 0{
                    self.stopanimation()
                    
                    self.performSegue(withIdentifier: "bardetail", sender: nil)
                }else{
                    self.flag = false
                    
                    DispatchQueue.main.async {
                        UIAlertView.init(title: "", message: "no record found", delegate: nil, cancelButtonTitle: "OK").show()
                        // LDAppSingleton.showAlert("Sorry!", "no record found")
                    }
                    //self.navigationController?.popViewController(animated: true)
                    let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = testController
                }
            }
        }else{
            //self.navigationController?.popViewController(animated: true)
        }
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // var pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!;
        // var image : CIImage = CIImage(cvPixelBuffer: pixelBuffer);
        
        //  DispatchQueue.main.async {
        // let image: UIImage? = GMVUtility.sampleBufferTo32RGBA(sampleBuffer)
        
    }
    
 }
