//
//  ContactVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 01/07/21.
//

import UIKit

class ContactVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var subjectView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var contactDateView: UIView!
    
    @IBOutlet weak var msgTxt: UITextView!
    @IBOutlet weak var subjectTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var mailTxt: UITextField!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var contactDateTxt: UITextField!
    
    let datePicker = UIDatePicker()
    var dateFormatter = DateFormatter()
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDashedBorder()
        contactDateTxt.delegate = self
        contactDateTxt.inputView = datePicker
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        contactDateTxt.inputAccessoryView = toolBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == contactDateTxt {
            datePicker.datePickerMode = .dateAndTime
        }
        
    }
    
    @objc func doneButtonTapped() {
        
        if contactDateTxt.isFirstResponder {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.contactDateTxt.text = formatter.string(from: datePicker.date)
             
        }
        self.view.endEditing(true)

    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func setDashedBorder() {
        self.fullNameView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.mailView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.phoneView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.subjectView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.messageView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.contactDateView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        //openSideMenu()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if self.fullNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Full name.")
            return
        } else if self.mailTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Email.")
            return
        } else if self.phoneTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Phone.")
            return
        } else if self.subjectTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Subject.")
            return
        } else if self.msgTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Message.")
            return
        } else if self.contactDateTxt.text!.isEmpty {
            self.view.makeToast("Please enter Contact Date.")
            return
        }
        
        self.contactUsApi()
        
    }
    
    func contactUsApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            
            let param:[String:Any] = ["name": self.fullNameTxt.text!, "email": self.mailTxt.text!, "phone": self.phoneTxt.text!, "subject": self.subjectTxt.text!, "message_text": self.msgTxt.text!, "selected_date": self.contactDateTxt.text!]
            
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CONTACT_US, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..

                    self.view.makeToast(json["message"].stringValue)
                    self.contactDateTxt.text = ""
                    self.fullNameTxt.text = ""
                    self.phoneTxt.text = ""
                    self.mailTxt.text = ""
                    self.subjectTxt.text = ""
                    self.msgTxt.text = ""
                    
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["data"].stringValue, buttonTitle: "Okay")
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
