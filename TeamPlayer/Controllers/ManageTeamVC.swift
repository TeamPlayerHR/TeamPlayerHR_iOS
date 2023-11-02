//
//  ManageTeamVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 05/08/21.
//

import UIKit
import Braintree
import BraintreeDropIn

class ManageTeamVC: UIViewController {
    
    @IBOutlet weak var groupListTableView: UITableView!
    
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var benchmarkTableView: UITableView!
    @IBOutlet weak var benchmarkListEmptyView: UIView!
    @IBOutlet weak var groupListEmptyView: UIView!
    @IBOutlet weak var participantEmptyView: UIView!
    @IBOutlet weak var pptSubLbl: UILabel!
    @IBOutlet weak var benchmarlTblHeight: NSLayoutConstraint!
    @IBOutlet weak var participantTblHeight: NSLayoutConstraint!
  
    @IBOutlet weak var groupTblHeight: NSLayoutConstraint!
    
    var teamParticipantObj = inviteTeamStruct()
    var teamUserListArr = [teamUserListStruct]()
    var teamBenchmarkListArr = [teamUserListStruct]()
    var teamParticipantArr = [teamUserListStruct]()
    var selectedPpcPptObj = teamUserListStruct()
    
    var clientToken = String()
    var orderId = String()
    var braintreeClient: BTAPIClient?
    var totalAmount : Double = Double()
    var amount = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showAndHideEmptyViews()
        self.categorizeUserTypes()
        self.getAmountApi()
        NotificationCenter.default.addObserver(self, selector: #selector(payPerClickPurchased), name: NSNotification.Name(rawValue: "payPerClickPurchased"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! UITableView) == self.benchmarkTableView {
          if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
              let newsize = newvalue as! CGSize
                benchmarlTblHeight.constant = newsize.height
//                self.participantTableView.height = newsize.height
            }
          }
        } else if (object as! UITableView) == self.participantTableView {
            if(keyPath == "contentSize"){
              if let newvalue = change?[.newKey]
              {
                let newsize = newvalue as! CGSize
                  participantTblHeight.constant = newsize.height
  //                self.participantTableView.height = newsize.height
              }
            }
            
        } else {
            if(keyPath == "contentSize"){
              if let newvalue = change?[.newKey]
              {
                let newsize = newvalue as! CGSize
                  groupTblHeight.constant = newsize.height
  //                self.participantTableView.height = newsize.height
              }
            }
            
        }
      }
    
    @objc func payPerClickPurchased() {
        self.autheticatePayment(paymentMethodNonce: "")
    }
    
    func showAndHideEmptyViews() {
        if self.teamUserListArr.count > 0 {
            self.groupListEmptyView.isHidden = true
        } else {
            self.groupListEmptyView.isHidden = false
            self.groupTblHeight.constant = 150.0
        }
        
        if self.teamBenchmarkListArr.count > 0 {
            self.benchmarkListEmptyView.isHidden = true
        } else {
            self.benchmarkListEmptyView.isHidden = false
            self.benchmarlTblHeight.constant = 150.0
        }
        
        if self.teamParticipantArr.count > 0 {
            self.participantEmptyView.isHidden = true
        } else {
            self.participantEmptyView.isHidden = false
            self.participantTblHeight.constant = 150.0
        }
    }
    
    func categorizeUserTypes() {
        let userListArr = self.teamParticipantObj.userList
        for items in userListArr {
            let item = items
            if item.user_type == "benchmark" {
                self.teamBenchmarkListArr.append(item)
            } else if item.user_type == "participant" {
                self.teamParticipantArr.append(item)
            } else {
                self.teamUserListArr.append(item)
            }
        }
        self.benchmarkTableView.reloadData()
        self.groupListTableView.reloadData()
        self.participantTableView.reloadData()
        self.showAndHideEmptyViews()
        self.pptSubLbl.text = "There are \(self.teamParticipantArr.count) Participants in this Questionnaire Group. Click a participant's name to view their questionnaire results."
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
    @IBAction func benchmarkBtnAction(_ sender: Any) {
        let indexPath: IndexPath? = groupListTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: groupListTableView))
        let teamUSerListObj = self.teamUserListArr[indexPath!.row]
        self.changeUserStateApi("benchmark", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        
        self.teamUserListArr.remove(at: indexPath!.row)
        //        self.benchmarkTableView.reloadData()
        //        self.groupListTableView.reloadData()
        //        self.showAndHideEmptyViews()
    }
    
    @IBAction func participantBtnAction(_ sender: Any) {
        let indexPath: IndexPath? = groupListTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: groupListTableView))
        let teamUSerListObj = self.teamUserListArr[indexPath!.row]
        self.changeUserStateApi("participant", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        
        self.teamUserListArr.remove(at: indexPath!.row)
        //        self.groupListTableView.reloadData()
        //        self.participantTableView.reloadData()
        //        self.showAndHideEmptyViews()
    }
    
    
    
    @IBAction func participantDelBtnAction(_ sender: UIButton) {
        if sender.tag == 101 {
            let indexPath: IndexPath? = benchmarkTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: benchmarkTableView))
            let teamUSerListObj = self.teamBenchmarkListArr[indexPath!.row]
            self.teamBenchmarkListArr.remove(at: indexPath!.row)
            self.changeUserStateApi("", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        } else {
            let indexPath: IndexPath? = participantTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: participantTableView))
            let teamUSerListObj = self.teamParticipantArr[indexPath!.row]
            self.teamParticipantArr.remove(at: indexPath!.row)
            self.changeUserStateApi("", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        }
        
        
    }
    
    @IBAction func benchmarkDelBtnAction(_ sender: UIButton) {
    }
    
    func changeUserStateApi(_ state: String, id: String, teamListObj: teamUserListStruct) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let apiUrl =  BASE_URL + PROJECT_URL.CHANGE_USER_TYPE
            
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            
            //            let param:[String:Any] = {"id":"2","user_type":"benchmark"}
            let param:[String:Any] = ["id":id,"user_type":state]
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    if json["data"]["user_type"].stringValue == "benchmark" {
                        self.teamBenchmarkListArr.append(teamListObj)
                    } else if json["data"]["user_type"].stringValue == "participant" {
                        self.teamParticipantArr.append(teamListObj)
                    } else {
                        self.teamUserListArr.append(teamListObj)
                    }
                    
                    DispatchQueue.main.async {
                        self.benchmarkTableView.reloadData()
                        self.groupListTableView.reloadData()
                        self.participantTableView.reloadData()
                        self.showAndHideEmptyViews()
                        self.pptSubLbl.text = "There are \(self.teamParticipantArr.count) Participants in this Questionnaire Group. Click a participant's name to view their questionnaire results."
                        
                        //self.categorizeUserTypes()
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
    
//    func getReportAPI(_ user_type: String, group_id: String, user_id: String, subgroup_id: String) {
//
//        if Reachability.isConnectedToNetwork() {
//            showProgressOnView(appDelegateInstance.window!)
//
//            let url = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(group_id)&user_id=\(user_id)&subgroup_id=\(subgroup_id)&user_type=\(user_type)&token=Bearer \(String(describing: UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)))"
//            let param:[String:String] = [:]
//            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: url, successBlock: { (json) in
//                print(json)
//                hideAllProgressOnView(appDelegateInstance.window!)
//                let success = json["success"].stringValue
//                if success == "true"
//                {
//
//
//
//                }
//                else {
//                    self.view.makeToast(json["message"].stringValue)
//                    // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
//                }
//            }, errorBlock: { (NSError) in
//                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
//                hideAllProgressOnView(appDelegateInstance.window!)
//            })
//
//        }else{
//            hideAllProgressOnView(appDelegateInstance.window!)
//            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
//        }
//    }
    
    func getReportAPI(_ user_type: String, group_id: String, user_id: String, subgroup_id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            let url = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(group_id)&user_id=\(user_id)&subgroup_id=\(subgroup_id)&user_type=\(user_type)&token=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)!)"
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: url, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    
                    
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

extension ManageTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == groupListTableView {
            return self.teamUserListArr.count
        } else if tableView == benchmarkTableView {
            return self.teamBenchmarkListArr.count
        } else {
            return self.teamParticipantArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == groupListTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! GroupListCell
            
            let userListObj = self.teamUserListArr[indexPath.row]
            cell.cellLbl.text = "Name: \(userListObj.user_name)"
            
            return cell
        } else if tableView == benchmarkTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BenchmarkListCell", for: indexPath) as! BenchmarkListCell
            
            let userListObj = self.teamBenchmarkListArr[indexPath.row]
            cell.cellLbl.text = "Name: \(userListObj.user_name)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantListCell", for: indexPath) as! ParticipantListCell
            
            let userListObj = self.teamParticipantArr[indexPath.row]
            cell.cellLbl.text = "Name: \(userListObj.user_name)"
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == benchmarkTableView {
            self.selectedPpcPptObj = self.teamBenchmarkListArr[indexPath.row]
            self.amount = "\(Double(self.teamParticipantArr.count + 1) * Double(self.amount)!)"
            if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.USER_ROLE) as! String == "3" {
//                self.getBrainTreeToken()
                IAPService.shared.purchase(product: .PayPerClick)
                IAPService.shared.isSubscriptionPurchased = "payPerClick"
            } else {
                let benhcmarkListObj = self.teamBenchmarkListArr[indexPath.row]
                let reportUrl = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(benhcmarkListObj.group_id)&user_id=\(benhcmarkListObj.user_id)&subgroup_id=\(benhcmarkListObj.subgroup_id)&user_type=benchmark&token=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)!)"
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewReportVC
                print(reportUrl)
                vc.urlStr = reportUrl
    //            vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            
        } else if tableView == participantTableView {
            self.selectedPpcPptObj = self.teamParticipantArr[indexPath.row]
            self.amount = "\(Double(self.teamBenchmarkListArr.count + 1) * Double(self.amount)!)"
            if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.USER_ROLE) as! String == "3" {
//                self.getBrainTreeToken()
                IAPService.shared.purchase(product: .PayPerClick)
            } else {
                let participantListObj = self.teamParticipantArr[indexPath.row]
                let reportUrl = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(participantListObj.group_id)&user_id=\(participantListObj.user_id)&subgroup_id=\(participantListObj.subgroup_id)&user_type=participant&token=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)!)"
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewReportVC
                vc.urlStr = reportUrl
    //            vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == benchmarkTableView {
            benchmarlTblHeight.constant = benchmarkTableView.contentSize.height
        } else if tableView == participantTableView {
            participantTblHeight.constant = participantTableView.contentSize.height
        } else {
            groupTblHeight.constant = groupListTableView.contentSize.height
        }
        
    }
    
    func getBrainTreeToken() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_BRAINTREE_TOKEN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                var success = json["success"].stringValue
                success = "true"
                if success == "true"
                {
                    self.clientToken = json["token"].stringValue
//                    //print(self.clientToken)
                    self.braintreeClient = BTAPIClient(authorization: self.clientToken)
//
                    self.showDropIn(clientTokenOrTokenizationKey: self.clientToken)
                    
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
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        request.applePayDisabled = false // Make sure that  applePayDisabled is false
        
        let dropIn = BTDropInController.init(authorization: clientTokenOrTokenizationKey, request: request) { (controller, result, error) in
            
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                controller.dismiss(animated: true, completion: nil)
                print("CANCELLED")
                
            } else if let result = result{
                
                switch result.paymentOptionType {
                case .applePay ,.payPal,.masterCard,.discover,.visa:
                    // Here Result success  check paymentMethod not nil if nil then user select applePay
                    if let paymentMethod = result.paymentMethod{
                        //paymentMethod.nonce  You can use  nonce now
                        
                        let nonce = result.paymentMethod!.nonce
                        print( nonce)
                        //self.postNonceToServer(paymentMethodNonce: nonce, deviceData : self.deviceData)
                        self.autheticatePayment(paymentMethodNonce: nonce)
                        controller.dismiss(animated: true, completion: nil)
                    }else{
                        
                        controller.dismiss(animated: true, completion: {
                            
                            self.braintreeClient = BTAPIClient(authorization: clientTokenOrTokenizationKey)
                            
                            // call apple pay
                            let paymentRequest = self.paymentRequest()
                            
                            // Example: Promote PKPaymentAuthorizationViewController to optional so that we can verify
                            // that our paymentRequest is valid. Otherwise, an invalid paymentRequest would crash our app.
                            
                            if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                                as PKPaymentAuthorizationViewController?
                            {
                                vc.delegate = self
                                self.present(vc, animated: true, completion: nil)
                            } else {
                                print("Error: Payment request is invalid.")
                            }
                            
                        })
                        
                    }
                default:
                    print("error")
                    controller.dismiss(animated: true, completion: nil)
                }
                
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            
            
        }
        
        self.present(dropIn!, animated: true, completion: nil)
        
    }
    
    func autheticatePayment(paymentMethodNonce: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = ["id": "\(self.selectedPpcPptObj.id)", "amount": self.amount, "sub_group_id": self.selectedPpcPptObj.subgroup_id, "data": "", "tranction_id": paymentMethodNonce]
            
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.UPDATE_PPC_PAYMENT, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.view.makeToast("Payment done successfully.")
                    let reportUrl = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(self.selectedPpcPptObj.group_id)&user_id=\(self.selectedPpcPptObj.user_id)&subgroup_id=\(self.selectedPpcPptObj.subgroup_id)&user_type=benchmark&token=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)!)"
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewReportVC
                    vc.urlStr = reportUrl
        //            vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
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
    
    
    func getAmountApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GEt_AppQuestionnairePurchase_AMOUNT, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    if json["data"].count > 0 {
                        self.amount =  json["data"][0]["amount"].stringValue
                        
                    }
                    
//
//
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//
                    
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

extension ManageTeamVC : PKPaymentAuthorizationViewControllerDelegate{
    
    func paymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        //paymentRequest.merchantIdentifier = "merchant.wuber1";
        paymentRequest.merchantIdentifier = "y7sk7rb548cyt9qy";
        paymentRequest.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa, PKPaymentNetwork.masterCard];
        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS;
        paymentRequest.countryCode = "US"; // e.g. US
        paymentRequest.currencyCode = "USD"; // e.g. USD
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Merchant", amount: 1.0),
            
        ]
        return paymentRequest
    }
    
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Swift.Void){
        
        // Example: Tokenize the Apple Pay payment
        let applePayClient = BTApplePayClient(apiClient: braintreeClient!)
        applePayClient.tokenizeApplePay(payment) {
            (tokenizedApplePayPayment, error) in
            guard let tokenizedApplePayPayment = tokenizedApplePayPayment else {
                // Tokenization failed. Check `error` for the cause of the failure.
                
                // Indicate failure via completion callback.
                completion(PKPaymentAuthorizationStatus.failure)
                
                return
            }
            
            // Received a tokenized Apple Pay payment from Braintree.
            // If applicable, address information is accessible in `payment`.
            
            // Send the nonce to your server for processing.
            print("nonce = \(tokenizedApplePayPayment.nonce)")
            
            //self.postNonceToServer(paymentMethodNonce: tokenizedApplePayPayment.nonce, deviceData: self.deviceData)
            self.autheticatePayment(paymentMethodNonce: tokenizedApplePayPayment.nonce)
            // Then indicate success or failure via the completion callback, e.g.
            completion(PKPaymentAuthorizationStatus.success)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
