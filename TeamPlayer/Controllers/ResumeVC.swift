//
//  ResumeVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 04/08/21.
//

import UIKit
import Braintree
import BraintreeDropIn

class ResumeVC: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var uploadCvBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var uplaodedCv = ""
    var param:[String:Any]!
    var completionHandlerCallback:((String?) ->Void)?
    var clientToken = String()
    var orderId = String()
    var braintreeClient: BTAPIClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Please select what would you like to upload?", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor(displayP3Red: 49/255.0, green: 128/255.0, blue: 152/255.0, alpha: 1.0)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(UIAlertAction(title: "Image", style: .default , handler:{ (UIAlertAction)in
            self.chooseType()
        }))
        alertController.addAction(UIAlertAction(title: "Document", style: .default , handler:{ (UIAlertAction)in
            self.clickFunction()
        }))
        
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
//        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func buyAction(_ sender: Any) {
        self.getBrainTreeToken()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if self.uplaodedCv.isEmpty {
            self.view.makeToast("Please upload Resume.")
            return
        }
        if self.completionHandlerCallback != nil {
            self.completionHandlerCallback!(self.uplaodedCv)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getBrainTreeToken() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_BRAINTREE_TOKEN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                var success = json["success"].stringValue
                success = "true"
                if success == "true"
                {
                    self.clientToken = json["token"].stringValue
//                    //print(self.clientToken)
                    self.braintreeClient = BTAPIClient(authorization: self.clientToken)
//
                    self.showDropIn(clientTokenOrTokenizationKey: self.clientToken)
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        request.applePayDisabled = false // Make sure that  applePayDisabled is false
        
        let dropIn = BTDropInController.init(authorization: clientTokenOrTokenizationKey, request: request) { (controller, result, error) in
            
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                controller.dismiss(animated: true, completion: nil)
                print("CANCELLED")
                
            } else if let result = result{
                
                switch result.paymentOptionType {
                case .applePay ,.payPal,.masterCard,.discover,.visa:
                    // Here Result success  check paymentMethod not nil if nil then user select applePay
                    if let paymentMethod = result.paymentMethod{
                        //paymentMethod.nonce  You can use  nonce now
                        
                        let nonce = result.paymentMethod!.nonce
                        print( nonce)
                        //self.postNonceToServer(paymentMethodNonce: nonce, deviceData : self.deviceData)
                        self.autheticatePayment(paymentMethodNonce: nonce)
                        controller.dismiss(animated: true, completion: nil)
                    }else{
                        
                        controller.dismiss(animated: true, completion: {
                            
                            self.braintreeClient = BTAPIClient(authorization: clientTokenOrTokenizationKey)
                            
                            // call apple pay
                            let paymentRequest = self.paymentRequest()
                            
                            // Example: Promote PKPaymentAuthorizationViewController to optional so that we can verify
                            // that our paymentRequest is valid. Otherwise, an invalid paymentRequest would crash our app.
                            
                            if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                                as PKPaymentAuthorizationViewController?
                            {
                                vc.delegate = self
                                self.present(vc, animated: true, completion: nil)
                            } else {
                                print("Error: Payment request is invalid.")
                            }
                            
                        })
                        
                    }
                default:
                    print("error")
                    controller.dismiss(animated: true, completion: nil)
                }
                
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            
            
        }
        
        self.present(dropIn!, animated: true, completion: nil)
        
    }
    
    func autheticatePayment(paymentMethodNonce: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
//            let param:[String:Any] = ["id": "\(self.selectedId)", "transaction_id": paymentMethodNonce]
            
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.UPDATE_AppSubscriptionPurchase, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.view.makeToast("Payment done successfully.")
//                    self.getGroupList()
                    
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                    // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
}

extension ResumeVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIDocumentMenuDelegate {
    
    
    func chooseType() {
        let alert = UIAlertController(title: "", message: "Select Mode", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = UIColor(displayP3Red: 49/255.0, green: 128/255.0, blue: 152/255.0, alpha: 1.0)
        
        let deletbutton =  UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {(action) in
            // self.Profileimage.image = #imageLiteral(resourceName: "customer.png")
            
        })
        // add the actions (buttons)
        let takephoto =  UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: {(action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
              //  UIApplication.topViewController()?.present(self.imagePicker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
            
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        let uploadphoto = UIAlertAction(title: "Upload Photo", style: UIAlertAction.Style.default, handler: {(action) in
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
          //  UIApplication.topViewController()?.present(self.imagePicker, animated: true, completion: nil)
            
            
        })
        
        alert.addAction(takephoto)
        alert.addAction(uploadphoto)
        //  alert.addAction(deletbutton)
        // show the alert
        self.present(alert, animated: true, completion: nil)
      //  UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func clickFunction() {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
       // UIApplication.topViewController()?.present(importMenu, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        self.present(
            alertVC,
            animated: true,
            completion: nil)
//        UIApplication.topViewController()?.present(
//            alertVC,
//            animated: true,
//            completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        let fileUrlkk = Foundation.URL(string: myURL.absoluteString)
        do {
            let data = try Data(contentsOf: fileUrlkk!)
            let imageSize: Int = data.count
            if Double(imageSize) / 1000000.0 < 25.0 {
                self.uploadFileAPI(data, fileNamee: myURL.lastPathComponent)
            }
        } catch {
            
        }
        
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        self.present(documentPicker, animated: true, completion: nil)
       // UIApplication.topViewController()?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        //UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData = chosenImage.jpegData(compressionQuality: 0.5)
        self.dismiss(animated: true, completion: nil)
     //   UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        
        self.requestNativeImageUpload(image: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadFileAPI(_ imageData: Data, fileNamee: String) {
        let params = ["file": ""] as Dictionary<String, AnyObject>
//        showProgressOnView(self.view)
        showProgressOnView(appDelegateInstance.window!)
        ImageUploadServerClass.sharedInstance.multipartPostRequestHandler("https://superadmin.teamplayerhr.com/api/user/upload", mimeType: "", fileName: fileNamee, params: params, fileData: imageData) { ( response: AnyObject?, error:NSError?, httpStatusCode:Int?) in
            //hideAllProgressOnView(self.view)
            hideProgressOnView(appDelegateInstance.window!)
            DispatchQueue.main.async(execute: {
                if error == nil && response != nil && response is NSDictionary && httpStatusCode == 200 {
                    let respDic = response as! NSDictionary
                    print(respDic)
                    self.uplaodedCv = respDic.value(forKey: "file") as! String
                    
                    
                }
            })
        }
    }
    
}

extension ResumeVC {
    func requestNativeImageUpload(image: UIImage) {
        showProgressOnView(appDelegateInstance.window!)
        guard let url = NSURL(string: "https://superadmin.teamplayerhr.com/api/user/upload") else { return }
        let boundary = generateBoundary()
        var request = URLRequest(url: url as URL)
        
        let parameters = ["file": ""]
        
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "ApiKey": ""
        ]
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                DispatchQueue.main.async {
                    hideAllProgressOnView(appDelegateInstance.window!)
                }
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonDic = json as! NSDictionary
                    print(jsonDic)
                    let data = jsonDic.value(forKey: "data") as! NSDictionary
                    self.uplaodedCv = data.value(forKey: "filename") as! String
                    
                } catch {
                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
                    }
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    struct Media {
        let key: String
        let fileName: String
        let data: Data
        let mimeType: String
        
        init?(withImage image: UIImage, forKey key: String) {
            self.key = key
            self.mimeType = "image/jpg"
            self.fileName = "\(arc4random()).jpeg"
            
            guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
            self.data = data
        }
    }
}

extension ResumeVC : PKPaymentAuthorizationViewControllerDelegate{
    
    func paymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        //paymentRequest.merchantIdentifier = "merchant.wuber1";
        paymentRequest.merchantIdentifier = "y7sk7rb548cyt9qy";
        paymentRequest.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa, PKPaymentNetwork.masterCard];
        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS;
        paymentRequest.countryCode = "US"; // e.g. US
        paymentRequest.currencyCode = "USD"; // e.g. USD
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Merchant", amount: 1.0),
            
        ]
        return paymentRequest
    }
    
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Swift.Void){
        
        // Example: Tokenize the Apple Pay payment
        let applePayClient = BTApplePayClient(apiClient: braintreeClient!)
        applePayClient.tokenizeApplePay(payment) {
            (tokenizedApplePayPayment, error) in
            guard let tokenizedApplePayPayment = tokenizedApplePayPayment else {
                // Tokenization failed. Check `error` for the cause of the failure.
                
                // Indicate failure via completion callback.
                completion(PKPaymentAuthorizationStatus.failure)
                
                return
            }
            
            // Received a tokenized Apple Pay payment from Braintree.
            // If applicable, address information is accessible in `payment`.
            
            // Send the nonce to your server for processing.
            print("nonce = \(tokenizedApplePayPayment.nonce)")
            
            //self.postNonceToServer(paymentMethodNonce: tokenizedApplePayPayment.nonce, deviceData: self.deviceData)
            self.autheticatePayment(paymentMethodNonce: tokenizedApplePayPayment.nonce)
            // Then indicate success or failure via the completion callback, e.g.
            completion(PKPaymentAuthorizationStatus.success)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
