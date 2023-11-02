//
//  InviteVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/07/21.
//

import UIKit
import AVFoundation

class InviteVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var teamEmptyView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inviteMailTxt: UITextField!
    @IBOutlet weak var teamNameTxt: UITextField!
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var remainingQuestionaireLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dashedView1: DashedView!
    @IBOutlet weak var dashedView: DashedView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    
    var groupId = ""
    var participantArr = [inviteParticipantStruct]()
    var teamsArr = [inviteTeamStruct]()
    var teamUserListArr = [teamUserListStruct]()
    var dispatchWorkItem: DispatchWorkItem?
    var remainingQuestionaire: Int = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
//        self.tableView.delegate = nil
//        self.tableView.dataSource = nil
        self.tableView.tableFooterView = UIView()
//        self.participantTableView.dataSource = nil
//        self.participantTableView.delegate = nil
        self.participantTableView.tableFooterView = UIView()
        self.dashedView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.dashedView1.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
//        self.getGroupDetail()
//        self.getTeamAPI()
        setUpTabController()
        /*
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 6/255.0, green: 159/255.0, blue: 190/255.0, alpha: 1.0)
        
        self.tabBarController?.tabBar.standardAppearance = appearance;
        if #available(iOS 15.0, *) {
            self.tabBarController?.tabBar.scrollEdgeAppearance = self.tabBarController?.tabBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
        */
        self.inviteMailTxt.delegate = self
        self.participantTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func setUpTabController () {
        
        if #available(iOS 13, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 6/255.0, green: 159/255.0, blue: 190/255.0, alpha: 1.0)
            
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            
            self.tabBarController?.tabBar.standardAppearance = appearance
            // Update for iOS 15, Xcode 13
            if #available(iOS 15.0, *) {
                self.tabBarController?.tabBar.scrollEdgeAppearance = appearance
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.getGroupDetail()
        self.getTeamAPI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! UITableView) == self.participantTableView {
          if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
              let newsize = newvalue as! CGSize
                tblHeightConstraint.constant = newsize.height
//                self.participantTableView.height = newsize.height
            }
          }
        } else {
            if(keyPath == "contentSize"){
              if let newvalue = change?[.newKey]
              {
                let newsize = newvalue as! CGSize
                  tableViewHeight.constant = newsize.height
  //                self.participantTableView.height = newsize.height
              }
            }
            
        }
      }

    
    @IBAction func createAction(_ sender: Any) {
        if self.teamNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter Team Name.")
            return
        }
        self.createTeamAPI()
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        if self.inviteMailTxt.text!.isEmpty {
            self.view.makeToast("Please enter Email Id.")
            return
        }
        self.sendInvitationAPI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paticipantCellBtnAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add to Team" {
            let indexPath: IndexPath? = participantTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: participantTableView))
             let participantObj = self.participantArr[indexPath!.row]
            self.openTeamActionSheet(participantObj.id, userName: participantObj.user_name)
            
        } else if sender.titleLabel?.text == "Show" {
           
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageTeamVC") as! ManageTeamVC
            let indexPath: IndexPath? = tableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: tableView))
             let teamUserListObj = self.teamsArr[indexPath!.row]
            vc.teamParticipantObj = teamUserListObj
//            vc.teamUserListArr = teamUserListObj
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let indexPath: IndexPath? = participantTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: participantTableView))
             let participantObj = self.participantArr[indexPath!.row]
            self.sendReminderAPI(participantObj.user_name, mail: participantObj.email)
            
        }
        
    }
    
    func sendReminderAPI(_ userName: String, mail: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["user_name": userName, "email": mail]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SEND_REMINDER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    
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
    
    
    func getGroupDetail() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_GROUP_DETAIL + "\(self.groupId)" + "&pname=\(self.searchBar.text!)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.participantArr.removeAll()
                    for i in 0..<json["data"]["survey_participants"].count {
                        let id =  json["data"]["survey_participants"][i]["profile_id"].stringValue
                        let user_name =  json["data"]["survey_participants"][i]["user_name"].stringValue
                        let survey_progress =  json["data"]["survey_participants"][i]["survey_progress"].boolValue
                        let email = json["data"]["survey_participants"][i]["email"].stringValue
                        
                        self.participantArr.append(inviteParticipantStruct.init(id: id, user_name: user_name, survey_progress: survey_progress, email: email))
                     }

                    DispatchQueue.main.async {
                        if self.participantArr.count > 0 {
                            self.participantTableView.dataSource = self
                            self.participantTableView.delegate = self
                            self.remainingQuestionaireLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.NAME) as! String) \(json["data"]["remaining"].stringValue) Questionnaire remaining"
                            self.remainingQuestionaire = Int(json["data"]["remaining"].stringValue) ?? 0
                            self.participantTableView.reloadData()
                        }
                    }
                    
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
    
    func getTeamAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": self.groupId]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_TEAMS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.teamsArr.removeAll()
                    for i in 0..<json["data"].count {
                        let id =  json["data"][i]["id"].stringValue
                        let group_id =  json["data"][i]["group_id"].stringValue
                        let name =  json["data"][i]["name"].stringValue
                        let userList = json["data"][i]["user_list"].arrayValue
                        let teamCount = userList.count
                        
                        self.teamUserListArr.removeAll()
                        for j in 0..<json["data"][i]["user_list"].count {
                            let user_type = json["data"][i]["user_list"][j]["user_type"].stringValue
                            let id = json["data"][i]["user_list"][j]["id"].stringValue
                            let user_name = json["data"][i]["user_list"][j]["user_name"].stringValue
                            let subgroup_id = json["data"][i]["user_list"][j]["subgroup_id"].stringValue
                            let group_id = json["data"][i]["user_list"][j]["group_id"].stringValue
                            let user_id = json["data"][i]["user_list"][j]["user_id"].stringValue
                            
                            self.teamUserListArr.append(teamUserListStruct.init(id: id, user_type: user_type, user_name: user_name, group_id: group_id, subgroup_id: subgroup_id, user_id: user_id))
                        }
                        
                        self.teamsArr.append(inviteTeamStruct.init(id: id, group_id: group_id, name: name, teamCount: "\(teamCount)", userList: self.teamUserListArr))
                     }

                    DispatchQueue.main.async {
                        if self.teamsArr.count > 0 {
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.isHidden = false
                            self.teamEmptyView.isHidden = true
//                            self.tableViewHeight.constant = CGFloat(self.teamsArr.count * 45)
                            self.tableView.reloadData()
                        } else {
                            self.tableView.isHidden = true
//                            self.teamEmptyView.isHidden = false
                        }
                    }
                    
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
    
    func sendInvitationAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": self.groupId, "email": self.inviteMailTxt.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SEND_INVITATION, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    self.inviteMailTxt.text = ""
                    
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
    
    
    func createTeamAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": self.groupId, "name": self.teamNameTxt.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CREATE_TEAM, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    self.teamNameTxt.text = ""
                    self.getTeamAPI()
                    
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
    
    func addToTeamAPI(_ name: String, subgroup_id: String, group_id: String, user_id: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": group_id, "user_name": name, "subgroup_id": subgroup_id, "user_id": user_id]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.ADD_TO_TEAM, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    self.getTeamAPI()
                    
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
    
    func openTeamActionSheet(_ userId: String, userName: String) {
        
        let alertController = UIAlertController(title: "Team", message: "Select Team", preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor(displayP3Red: 49/255.0, green: 128/255.0, blue: 152/255.0, alpha: 1.0)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        for item in self.teamsArr{
            let classButton = UIAlertAction(title: item.name , style: .default, handler: { (action) in
                
                self.addToTeamAPI(userName, subgroup_id: item.id, group_id: item.group_id, user_id: userId)
            })
            alertController.addAction(classButton)
        }
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func showInviteesAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowInviteeVC") as! ShowInviteeVC
        vc.id = self.groupId
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MultipleInviteVC") as! MultipleInviteVC
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.inviteMailTxt {
//            if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.USER_ROLE) as! String == "3" {
            if self.remainingQuestionaire == 0 {
                textField.resignFirstResponder()
                self.showNoCreditAlert()
            } else {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MultipleInviteVC") as! MultipleInviteVC
                vc.groupId = self.groupId
                vc.remainingQuestionaire = self.remainingQuestionaire
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
                
//            }
        }
    }
    
    func showNoCreditAlert() {
        let alert = UIAlertController(title: "No Credits !!", message: "Please purchase app questionnaire.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in

            guard let window = UIApplication.shared.delegate?.window else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
            viewController.selectedIndex = 3
                                    
            window!.rootViewController = viewController
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.5
            UIView.transition(with: window!, duration: duration, options: options, animations: {}, completion:
                                { completed in
                window!.makeKeyAndVisible()
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)

    }
}

extension InviteVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == participantTableView {
            return self.participantArr.count
        } else {
            return self.teamsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == participantTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteParticipantCell", for: indexPath) as! InviteParticipantCell
            
            let groupListObj = self.participantArr[indexPath.row]
            cell.cellNameLbl.text = "Name: \(groupListObj.user_name)"
            cell.cellStatusLbl.text = "Status: \(groupListObj.survey_progress ? "Complete" : "Not Complete")"
            
            cell.cellBtn.setTitle(groupListObj.survey_progress ? "Add to Team" : "Send Reminder", for: .normal)
            cell.cellBtn.tintColor = UIColor.white
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteParticipantCell", for: indexPath) as! InviteParticipantCell
            
            let groupListObj = self.teamsArr[indexPath.row]
            cell.cellNameLbl.text = "Team Name: \(groupListObj.name)"
            cell.cellStatusLbl.text = "Participants: \(groupListObj.teamCount)"
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == participantTableView {
            tblHeightConstraint.constant = participantTableView.contentSize.height
        } else {
//            tableViewHeight.constant = tableView.contentSize.height
        }
        
    }
    
}

extension InviteVC: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.filterView.isHidden = true
        
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            dispatchWorkItem?.cancel()
//            let totalChar = searchBar.text!.count
            let productSearchWorkItem = DispatchWorkItem{
                if searchText.count > 0{
                    self.participantArr.removeAll()
//                    self.getTutorWithSearch(searchText: searchBar.text!)
                    self.getGroupDetail()
                }else if searchText.count == 0{
                    self.participantArr.removeAll()
                    self.searchBar.endEditing(true)
//                    self.getAllApprovedTutor()
                    self.getGroupDetail()
                }
            }
            
            dispatchWorkItem = productSearchWorkItem
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: productSearchWorkItem)
            
        }
     
}
