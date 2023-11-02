//
//  DeleteVC.swift
//  TeamPlayer
//
//  Created by ChawTech Solutions on 12/04/23.
//

import UIKit

class DeleteVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickPrivacy(_ sender: UIButton) {
        guard let url = URL(string: "https://teamplayerhr.com/privacy-policy") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        //openSideMenu()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
            
            self.showAlertWithActions("Are you sure you want to Delete your account ?", titles: ["Yes", "No"]) { (value) in
                if value == 1{
                    self.deleteAccountAPI()
                }
            }
    }
    
    func deleteAccountAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let fullUrl = BASE_URL + PROJECT_URL.DELETE_ACCOUNT
            let param:[String:String] = [:]
            
            ServerClass.sharedInstance.deleteRequestWithUrlParameters(param, path: fullUrl, successBlock: {  (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success  == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.USER_ROLE)
                    inviteGroupArr.removeAll()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        guard let window = UIApplication.shared.delegate?.window else {
                            return
                        }
                        
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController 
                        
                        window!.rootViewController = viewController
                        let options: UIView.AnimationOptions = .transitionCrossDissolve
                        let duration: TimeInterval = 0.5
                        UIView.transition(with: window!, duration: duration, options: options, animations: {}, completion:
                                            { completed in
                            window!.makeKeyAndVisible()
                        })
                    }
                    
                }
                else {
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
    
}
