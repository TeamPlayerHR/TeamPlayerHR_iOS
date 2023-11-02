//
//  MultipleInviteVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 24/01/22.
//

import UIKit

class MultipleInviteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOfRows: Int = 1
    var groupId = ""
    var remainingQuestionaire: Int = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inviteeName = [""]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func sendInvitesAction(_ sender: UIButton) {
        var isEmpty = true
        for i in inviteeName {
            if i != "" {
                isEmpty = false
                break
            }
        }
        if isEmpty {
            self.view.makeToast("Please add any email.")
        } else {
            self.sendMultipleInvitationAPI()
        }
        
    }
    
    @IBAction func addMoreAction(_ sender: UIButton) {
//        self.numberOfRows += 1
        if inviteeName.count == self.remainingQuestionaire {
            self.view.makeToast("You can only invite \(self.remainingQuestionaire) participants. Please buy more questionaire in order to invite more participants.")
            return
        } else if inviteeName.count == 15 {
            self.view.makeToast("You can only invite 15 participants at a time.")
            return
        } else {
            inviteeName.insert("", at: inviteeName.count)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func sendMultipleInvitationAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
//            let characterToRemove: Character = " "
//            let filteredString = String(self.inviteeName.filter { $0 != characterToRemove })
//            print(filteredString)
            
            inviteeName = inviteeName.filter { $0 != "" }
            let param:[String:Any] = ["group_id": self.groupId, "emails": inviteeName]
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SEND_MULTIPLE_INVITATION, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
//                    inviteeName.removeAll()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                else {
                    self.view.makeToast(json["message"].stringValue)
                   // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                self.view.makeToast(NSError.localizedDescription)
//                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteeName.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleInviteTableCell", for: indexPath) as! MultipleInviteTableCell
        
        cell.cellLbl.text = "\(indexPath.row)"
        cell.cellTxtFeild.text = inviteeName[indexPath.row] as! String
        cell.row = indexPath.row
//        cell.completionHandlerCallback = { [self](newInviteeName: [String]!)->Void in
//
//            inviteeName = newInviteeName
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt pressed")
    }
}
