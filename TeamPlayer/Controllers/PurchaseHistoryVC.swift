//
//  PurchaseHistoryVC.swift
//  TeamPlayer
//
//  Created by Ashish Nimbria on 12/17/21.
//

import UIKit

class PurchaseHistoryVC: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableViewPurchseHistory: UITableView!
    
    var planType: String = String()
    var purchaseHistoryListArr = [purchaseHistoryStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getPurchaseHistoryAPI()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func menuAction(_ sender: Any) {
//        openSideMenu()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        
    }
    
    func getPurchaseHistoryAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            var urlString = ""
            
            if self.planType == "PPC Purchase" {
                urlString = BASE_URL + PROJECT_URL.GET_AppPPCPurchase_HISTORY
            } else if self.planType == "Renewal Purchase" {
                urlString = BASE_URL + PROJECT_URL.GET_RenewalPurchase_HISTORY
            } else if self.planType == "Full Questionaire Purchase" {
                urlString = BASE_URL + PROJECT_URL.GET_FullQuestionnairePurchase_HISTORY
            } else if self.planType == "App Subscription Purchase" {
                urlString = BASE_URL + PROJECT_URL.GET_AppSubscriptionPurchase_HISTORY
            } else if self.planType == "Subscription Purchase" {
                urlString = BASE_URL + PROJECT_URL.GET_SubscriptionPurchase_HISTORY
            } else {
                urlString = BASE_URL + PROJECT_URL.GET_AppQuestionnairePurchase_HISTORY
                
            }
            
            
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlString, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.purchaseHistoryListArr.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let amount =  json["data"][i]["amount"].stringValue
                        let on_date =  json["data"][i]["on_date"].stringValue
                        let no_of_participant =  json["data"][i]["no_of_participant"].stringValue
                        let title =  json["data"][i]["plan_title"].stringValue
                        let detail =  json["data"][i]["detail"].stringValue
                        
                        self.purchaseHistoryListArr.append(purchaseHistoryStruct.init(amount: amount, on_date: on_date, no_of_participant: no_of_participant, title:title, detail:detail))
                    }

                    if self.purchaseHistoryListArr.count > 0 {
                        DispatchQueue.main.async {
                            self.tableViewPurchseHistory.isHidden = false
                            self.emptyView.isHidden = true
                            self.tableViewPurchseHistory.reloadData()

                        }
                    } else {
                        self.tableViewPurchseHistory.isHidden = true
                        self.emptyView.isHidden = false
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

}

extension PurchaseHistoryVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.purchaseHistoryListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseHistoryCell", for: indexPath) as! PurchaseHistoryCell
        let info = self.purchaseHistoryListArr[indexPath.row]
        cell.cellAmountLbl.text = info.amount
        cell.cellDateLbl.text = info.on_date
        cell.cellParticipantLbl.text = info.no_of_participant
        cell.cellPlanTypeLbl.text = info.title
        cell.cellPlanDetailLbl.text = info.detail
        return cell
    }
    
    
}
