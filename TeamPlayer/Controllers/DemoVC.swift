//
//  DemoVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/06/21.
//

import UIKit
import Toast_Swift

class DemoVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var mailVIew: UIView!
    @IBOutlet weak var designationView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var slotView: UIView!
    
    @IBOutlet weak var mailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var designationTxt: UITextField!
    @IBOutlet weak var slotTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    
    let datePicker = UIDatePicker()
    var dateFormatter = DateFormatter()
    var toolBar = UIToolbar()
    
    var designation = ""
    var slot = ""
    
    var isAgreePrivacy = false
    var isAgreeTerms = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDashedBorder()
        
        dateTxt.delegate = self
        timeTxt.delegate = self
        
        dateTxt.inputView = datePicker
        timeTxt.inputView = datePicker
        
        
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateTxt.inputAccessoryView = toolBar
        timeTxt.inputAccessoryView = toolBar
        
        if isDemo {
            self.backBtn.setImage(UIImage.init(named: "back"), for: .normal)
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
    
    func setDashedBorder() {
        self.fullNameView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.companyNameView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.phoneView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.mailVIew.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.designationView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.slotView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.dateView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.timeView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTxt {
            datePicker.datePickerMode = .date
        }
        if textField == timeTxt {
            datePicker.datePickerMode = .time
        }
        
    }
    
    @objc func doneButtonTapped() {
        
        if dateTxt.isFirstResponder {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            dateTxt.text = formatter.string(from: datePicker.date)
            
        }
        if timeTxt.isFirstResponder {
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            formatter.dateFormat = "hh:mm"
            timeTxt.text = formatter.string(from: datePicker.date)
            
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func designationBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: "Select Role", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "CEO", style: .default , handler:{ (UIAlertAction)in
            self.designation = "1"
            self.designationTxt.text = "CEO"
        }))
        
        alert.addAction(UIAlertAction(title: "HR Manager", style: .default , handler:{ (UIAlertAction)in
            self.designation = "2"
            self.designationTxt.text = "HR Manager"
        }))
        
        alert.addAction(UIAlertAction(title: "HR Consultant", style: .default , handler:{ (UIAlertAction)in
            self.designation = "3"
            self.designationTxt.text = "HR Consultant"
        }))
        
        alert.addAction(UIAlertAction(title: "HR Genralist", style: .default , handler:{ (UIAlertAction)in
            self.designation = "4"
            self.designationTxt.text = "HR Genralist"
        }))
        
        alert.addAction(UIAlertAction(title: "Leader", style: .default , handler:{ (UIAlertAction)in
            self.designation = "5"
            self.designationTxt.text = "Leader"
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .default , handler:{ (UIAlertAction)in
            self.designation = "6"
            self.designationTxt.text = "Other"
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func slotBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: "Number of Employees", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "1 - 20", style: .default , handler:{ (UIAlertAction)in
            self.slot = "1 - 20"
            self.slotTxt.text = "1-20"
        }))
        
        alert.addAction(UIAlertAction(title: "21 - 80", style: .default , handler:{ (UIAlertAction)in
            self.slot = "21 - 80"
            self.slotTxt.text = "21-80"
        }))
        
        alert.addAction(UIAlertAction(title: "81 - 500", style: .default , handler:{ (UIAlertAction)in
            self.slot = "81 - 500"
            self.slotTxt.text = "81-500"
        }))
        
        alert.addAction(UIAlertAction(title: "+500", style: .default , handler:{ (UIAlertAction)in
            self.slot = "+500"
            self.slotTxt.text = "+500"
        }))
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func backBtnAtion(_ sender: UIButton) {
        if isDemo {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)

           // openSideMenu()
        }
        
    }
    
    
    @IBAction func acceptBtnAction(_ sender: UIButton) {
        if sender.currentImage == UIImage.init(named: "uncheck") {
            sender.setImage(UIImage.init(named: "checked"), for: .normal)
           // self.isTermsAgreed = true
        } else {
            sender.setImage(UIImage.init(named: "uncheck"), for: .normal)
            //self.isTermsAgreed = false
        }
        self.isAgreePrivacy = true
    }
    
    func demoRequestAPI() {

        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            let param:[String:Any] = [ "first_name": self.fullNameTxt.text!,"last_name":self.fullNameTxt.text!, "email":self.mailTxt.text!, "user_role":self.designation, "phone":self.phoneTxt.text!, "no_of_employees":self.slot, "organization_name": self.companyNameTxt.text!, "agreeTerms": self.isAgreePrivacy, "agreePrivacy": self.isAgreePrivacy, "selected_date": "\(self.dateTxt.text!) \(self.timeTxt.text!)"]
            
            print(param)

            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.DEMO_REQUEST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..

                    self.view.makeToast(json["message"].stringValue)
                    self.fullNameTxt.text = ""
                    self.companyNameTxt.text = ""
                    self.mailTxt.text = ""
                    self.phoneTxt.text = ""
                    self.designationTxt.text = ""
                    self.slotTxt.text = ""
                    self.dateTxt.text = ""
                    self.timeTxt.text = ""

                }
                else {
                    self.view.makeToast(json["message"].stringValue)
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
    
    @IBAction func submitAction(_ sender: Any) {
        if fullNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter Full Name.")
            return
        } else if companyNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter Company name.")
            return
        } else if phoneTxt.text!.isEmpty {
            self.view.makeToast("Please enter Phone.")
            return
        } else if mailTxt.text!.isEmpty {
            self.view.makeToast("Please enter Mail.")
            return
        } else if designationTxt.text!.isEmpty {
            self.view.makeToast("Please enter Designation.")
            return
        } else if slotTxt.text!.isEmpty {
            self.view.makeToast("Please enter No. of employees.")
            return
        } else if dateTxt.text!.isEmpty {
            self.view.makeToast("Please enter Date.")
            return
        } else if timeTxt.text!.isEmpty {
            self.view.makeToast("Please enter Time.")
            return
        } else if !self.isAgreePrivacy {
            self.view.makeToast("Please agree to our Terms and Policies.")
            return
        }
        self.demoRequestAPI()
    }
    
    
}
