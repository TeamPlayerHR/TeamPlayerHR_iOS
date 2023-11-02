//
//  SideMenuVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 30/06/21.
//

import UIKit

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
//    var sideMenuArr = ["Home","Participants Profile", "Purchase Breif Qestionaores", "Compare IM Intrinsic Matrix", "How it Works","What are the benefits", "Vision and Technology", "FAQ's", "Contact Us", "Subscription", "Demo", "News", "Logout"]
    var sideMenuArr = ["Home","Profile", "Purchase APP Questionnaire", "Compare Mobile APP IM’s (Intrinsic Matrix)", "Company Subscription", "Value Calculator", "Vision and Technology", "FAQ's", "Request Demo", "Contact Us", "News", "Purchase History", "Privacy Policy", "Terms of Use", "Delete Account" , "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell

        cell.cellLbl.text = self.sideMenuArr[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
            vc.showTabbar = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GroupVC") as! GroupVC
            vc.showTabbar = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 4 {
//            if let url = URL(string: "https://dev.teamplayerhr.com/purchase") {
//                UIApplication.shared.open(url)
//            }
        } else if indexPath.row == 4 {
//            self.view.makeToast("Under Development")
            let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "HowItWorksVC") as! HowItWorksVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            
            if let url = URL(string: "https://dev.teamplayerhr.com/mobile-value-calculator") {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 6 {
            let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "VisionVC") as! VisionVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DemoVC") as! DemoVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
            let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "NewsNewVC") as! NewsNewVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 11 {
            let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "PurchasePlanVC") as! PurchasePlanVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 12 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 13 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsOfUseVC") as! TermsOfUseVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 14 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteVC") as! DeleteVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
            self.view.makeToast("User Logged Out")
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
    }

}
