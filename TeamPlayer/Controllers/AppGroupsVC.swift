//
//  AppGroupsVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 01/02/22.
//

import UIKit

class AppGroupsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTitle: UILabel!
    
    var pendingInvitationGroupArr = [pendingGroupStruct]()
    var inviteGroupArr = [inviteGroupStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.tableFooterView = UIView()
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
        
        self.getGroupList()
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
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.getPendingGroupList()
    }
    
    @IBAction func menuAction(_ sender: Any) {
        openSideMenu()
    }
    
    func getGroupList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_GROUP_JOINED, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    if json["data"].count > 0 {
                        let subscriptionStatus = json["data"][0]["subscription"].boolValue
//                        if subscriptionStatus == false {
//                            self.getPlanAPI()
//                        } else {
                            self.inviteGroupArr.removeAll()

                            for i in 0..<json["data"].count {
                                let id =  json["data"][i]["id"].stringValue
                                let name =  json["data"][i]["name"].stringValue
                                let max_size =  json["data"][i]["max_size"].stringValue
                                let survey_progress = json["data"][i]["survey_progress"].boolValue
//                                if !survey_progress {
//                                    self.alertView.isHidden = false
//                                }
                                
                                self.inviteGroupArr.append(inviteGroupStruct.init(id: id, name: name, max_size: max_size, survey_progress: survey_progress))
//                             }

                            DispatchQueue.main.async {
                                if self.inviteGroupArr.count > 0 {
                                    
                                    self.tableView.dataSource = self
                                    self.tableView.delegate = self
                                    self.tableView.reloadData()
                                    self.headerTitle.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.NAME) as! String
                                }
                            }
                        }
                    }
//                    if json["message"].stringValue == "Please subscribe to access app features." {
//
//                        self.getPlanAPI()
//
//                    } else {
//                        self.inviteGroupArr.removeAll()
//
//                        for i in 0..<json["data"].count {
//                            let id =  json["data"][i]["id"].stringValue
//                            let name =  json["data"][i]["name"].stringValue
//                            let max_size =  json["data"][i]["max_size"].stringValue
//
//                            self.inviteGroupArr.append(inviteGroupStruct.init(id: id, name: name, max_size: max_size))
//                         }
//
//                        DispatchQueue.main.async {
//                            if self.inviteGroupArr.count > 0 {
//
//                                self.tableView.dataSource = self
//                                self.tableView.delegate = self
//                                self.tableView.reloadData()
//                                self.groupView.isHidden = false
//                                self.subscriptionView.isHidden = true
//                            }
//                        }
//                    }

                    
                    
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
    
    func getPendingGroupList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_INVITATION, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.pendingInvitationGroupArr.removeAll()

                    for i in 0..<json["data"].count {
                        let id =  json["data"][i]["group"]["id"].stringValue
                        let name =  json["data"][i]["group"]["name"].stringValue
                        let max_size =  json["data"][i]["group"]["max_size"].stringValue
                        let code = json["data"][i]["group"]["code"].stringValue

                        self.pendingInvitationGroupArr.append(pendingGroupStruct.init(id: id, name: name, max_size: max_size, code: code))
                     }
                    
                    DispatchQueue.main.async {
                            
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.reloadData()
                           
                            self.headerTitle.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.NAME) as! String
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
    
    func joinGroupAPI(_ groupInfo: pendingGroupStruct) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "id": groupInfo.id,"name":groupInfo.name,"code":groupInfo.code,"max_size":groupInfo.max_size,"test":"2"]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.JOIN_GROUP, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    
                    self.view.makeToast(json["message"].stringValue)
                    let group = DispatchGroup()
                    
                    group.enter()
                    self.setScore(groupInfo.id)
                    group.leave()
                    
                    group.enter()
                    self.getGroupList()
                    group.leave()
                    
                    group.enter()
                    self.getPendingGroupList()
                    group.leave()
                    
                    group.notify(queue: .main) {
                        // All requests completed
                        DispatchQueue.main.async {
                            //process success
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
    
    func setScore(_ groupId: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "test": "2","group_id":"\(groupId)"]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SET_SCORE, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
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

}

extension AppGroupsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.pendingInvitationGroupArr.count > 0 {
            return 2
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return self.inviteGroupArr.count
            } else {
                return self.pendingInvitationGroupArr.count
            }
 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
                
                let groupListObj = self.inviteGroupArr[indexPath.row]
                cell.cellLbl.text = "\(groupListObj.name)"
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
                
                let groupListObj = self.pendingInvitationGroupArr[indexPath.row]
                cell.cellLbl.text = "Join \(groupListObj.name)"
                
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0 {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
                headerView.backgroundColor = .white
                
                let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
                headerLabel.text = "App Questionaire Group Joined"

                headerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
                headerView.addSubview(headerLabel)
                
                return headerView
            } else {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
                headerView.backgroundColor = .white
                
                let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
                headerLabel.text = "Pending Invitation"

                headerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
                headerView.addSubview(headerLabel)
                
                return headerView
            }

        

    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//            if self.pendingInvitationGroupArr.count > 0 {
//                if section == 1 {
//                    let label = UILabel()
//                    label.numberOfLines = 0
//                    label.text = "Intrinsic Matrix – IM. When the TeamPlayerUK profile questionnaire is taken by participants, it establishes their Intrinsic Matrix - compatibility profile.  The “IM” acquires its value when compared to other members of current or planned teams. The results of these comparisons are used to match participants to the right employers/team leaders and current team members to help create the most compatible teams. The match is not skills or talent based, so, it accelerates hiring decisions, de-risks team building and helps improve productivity, reduces the costs of hiring new staff and minimizes hiring mistakes."
//                    label.textColor = .gray
//                    label.font = UIFont(name: "Roboto-Medium", size: 14)
//                    return label
//                } else {
//                    return nil
//                }
//
//            } else {
//                if section == 0 {
//                    let label = UILabel()
//                    label.numberOfLines = 0
//                    label.text = "Intrinsic Matrix – IM. When the TeamPlayerUK profile questionnaire is taken by participants, it establishes their Intrinsic Matrix - compatibility profile.  The “IM” acquires its value when compared to other members of current or planned teams. The results of these comparisons are used to match participants to the right employers/team leaders and current team members to help create the most compatible teams. The match is not skills or talent based, so, it accelerates hiring decisions, de-risks team building and helps improve productivity, reduces the costs of hiring new staff and minimizes hiring mistakes."
//                    label.textColor = .gray
//                    label.font = UIFont(name: "Roboto-Medium", size: 14)
//                    return label
//                } else {
//                    return nil
//                }
//
//            }
//
//
//
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 1 {
//            return 300
//        } else {
//            return 0
//        }
//    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let groupListObj = self.inviteGroupArr[indexPath.row]
            
            if groupListObj.max_size != "0" {
                let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "QuestionaireVC") as! QuestionaireVC
                vc.groupId = groupListObj.id
                vc.modalPresentationStyle = .fullScreen
                //self.navigationController?.pushViewController(vc, animated: true)
                self.present(vc, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "No credits", message: "Please purchse app questionnaire.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in

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
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                    self.getGroupList()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
                let groupListObj = self.pendingInvitationGroupArr[indexPath.row]
                let alert = UIAlertController(title: "Join Group", message: "Are you sure you want to join this group ?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    
                    self.joinGroupAPI(groupListObj)
                    
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                    self.getGroupList()
                }))
                self.present(alert, animated: true, completion: nil)

            }
            
        
    }
    

}
