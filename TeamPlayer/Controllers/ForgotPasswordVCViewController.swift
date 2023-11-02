//
//  ForgotPasswordVCViewController.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/06/21.
//

import UIKit

class ForgotPasswordVCViewController: UIViewController {

    @IBOutlet weak var forgotView: UIView!
    @IBOutlet weak var mailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.forgotView.roundRadius(options: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 30)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if self.mailTxt.text!.isEmpty {
            self.view.makeToast("Please enter your email.")
            return
        }
        self.forgotPswrdApi()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func forgotPswrdApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            
            let param:[String:Any] = ["email": self.mailTxt.text!]
            
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.FORGET_PASSWORD, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
//                    UserDefaults.standard.setValue(json["otpId"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)
                    
                    self.view.makeToast(json["message"].stringValue)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
                        vc.modalPresentationStyle = .fullScreen
                       // self.navigationController?.pushViewController(vc, animated: true)
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                }
                else {
//                    UIAlertController.showInfoAlertWithTitle("Message", message: json["data"].stringValue, buttonTitle: "Okay")
                    self.view.makeToast(json["data"].stringValue)
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
