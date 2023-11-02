//
//  HomeVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/06/21.
//

import UIKit
import SideMenu
import youtube_ios_player_helper

class HomeVC: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var alertTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var v1HeadingLbl: UILabel!
    @IBOutlet weak var v1ContentLbl: UILabel!
    @IBOutlet weak var v2HeadingLbl: UILabel!
    @IBOutlet weak var v2ContentLbl: UILabel!
    @IBOutlet weak var v3HeadingLbl: UILabel!
    @IBOutlet weak var v3ContentLbl: UILabel!
    @IBOutlet weak var v4HeadingLbl: UILabel!
    @IBOutlet weak var v4ContentLbl: UILabel!
    @IBOutlet weak var v5HeadingLbl: UILabel!
    @IBOutlet weak var lastViewContentLbl: UILabel!
    
    
    var fromSideMenu: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        playerView.delegate = self
        playerView.load(withVideoId: "1OxRDJe0pFI", playerVars: ["playsinline": 1])
        
        self.v1HeadingLbl.text = "• Employee Productivity"
        self.v1ContentLbl.text = "Decrease the 20% to 30% lost productivity that companies suffer due to unhappy and poorly engaged employees"
        self.v2HeadingLbl.text = "• Team Assignments"
        self.v2ContentLbl.text = "Savings of up to 20% when better aligned teams are operating on agile initiatives"
        self.v3HeadingLbl.text = "• Management Focus"
        self.v3ContentLbl.text = "Management Focus - A decrease of up to 20% of manager time focused on HR issues"
        self.v4HeadingLbl.text = "• Staff Hiring"
        self.v4ContentLbl.text = "Building Teams - An increase of up to 20% in employee productivity"
        self.v5HeadingLbl.text = "Augmenting Teams - Up to 30% reduction in the number and cost of bad hire"
        self.lastViewContentLbl.text = "TeamPlayerHR is not a psychometric test.\nTeamPlayerHR patented technology quickly assesses how individuals will interact with each other and tells its users whether individuals will work together effectively by assessing their cultural compatibility so they can create high performing teams."
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpTabController()
        
//        if inviteGroupArr.count == 0 {
//            self.getGroupList()
//        } else {
//            for i in 0..<inviteGroupArr.count {
//                let inviteGroupObj = inviteGroupArr[i]
//                if !inviteGroupObj.survey_progress || self.fromSideMenu {
////                    self.alertView.isHidden = false
//                }
//            }
//        }
   
        /*
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 6/255.0, green: 159/255.0, blue: 190/255.0, alpha: 1.0)
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        self.tabBarController?.tabBar.standardAppearance = appearance;
        if #available(iOS 15.0, *) {
           // self.tabBarController?.tabBar.scrollEdgeAppearance = self.tabBarController?.tabBar.standardAppearance
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearance

        } else {
            // Fallback on earlier versions
        }
        */
        
        
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
//        self.getGroupList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.playerView.stopVideo()
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    @IBAction func onTapSideMenu(_ sender: Any) {
        
//        if isDemo {
//            let menu = storyboard!.instantiateViewController(withIdentifier: "EarlySideMenuVC") as! SideMenuNavigationController
//            var settings = SideMenuSettings()
//            settings.menuWidth = self.view.frame.width - 100
//            menu.settings = settings
//            present(menu, animated: true, completion: nil)
//
//        } else {
//
//            let menu = storyboard!.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuNavigationController
//            var settings = SideMenuSettings()
//            settings.menuWidth = self.view.frame.width - 100
//            menu.settings = settings
//            present(menu, animated: true, completion: nil)
//        }
        let menu = storyboard!.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuNavigationController
        var settings = SideMenuSettings()
        settings.menuWidth = self.view.frame.width - 100
        menu.settings = settings
        present(menu, animated: true, completion: nil)
        
    }
    
    @IBAction func onTapNotification(_ sender: Any) {
        
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
                    inviteGroupArr.removeAll()

                    for i in 0..<json["data"].count {
                        let id =  json["data"][i]["id"].stringValue
                        let name =  json["data"][i]["name"].stringValue
                        let max_size =  json["data"][i]["max_size"].stringValue
                        let survey_progress = json["data"][i]["survey_progress"].boolValue
                        if !survey_progress || self.fromSideMenu {
                            self.alertView.isHidden = false
                        }
                        
                        inviteGroupArr.append(inviteGroupStruct.init(id: id, name: name, max_size: max_size, survey_progress: survey_progress))
                     }

                    DispatchQueue.main.async {
                        if inviteGroupArr.count > 0 {
                            
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.reloadData()
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
    
    @IBAction func alertCloseAction(_ sender: Any) {
        self.alertView.isHidden = true
    }
    
    

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteGroupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertGroupCell", for: indexPath) as! AlertGroupCell
        
        let groupListObj = inviteGroupArr[indexPath.row]
        cell.cellLbl.text = groupListObj.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupListObj = inviteGroupArr[indexPath.row]
        let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "QuestionaireVC") as! QuestionaireVC
        vc.groupId = groupListObj.id
        vc.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
