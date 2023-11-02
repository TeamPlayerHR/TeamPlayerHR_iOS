//
//  GroupVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/07/21.
//

import UIKit
import Braintree
import BraintreeDropIn

class GroupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblViewSubscription: UITableView!
    @IBOutlet weak var backMenuBtn: UIButton!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var headerGroupTitle: UILabel!
    
    
    var inviteGroupArr = [inviteGroupStruct]()
    var pendingInvitationGroupArr = [pendingGroupStruct]()
    var subscriptionListArr = [subscriptionListStruct]()
    var clientToken = String()
    var orderId = String()
    var braintreeClient: BTAPIClient?
    var showTabbar:Bool? = true
//    var totalAmount : Double = Double()
//    var selectedId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.tableFooterView = UIView()
        self.tblViewSubscription.dataSource = nil
        self.tblViewSubscription.delegate = nil
        self.tblViewSubscription.tableFooterView = UIView()
       // setUpTabController()
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
        NotificationCenter.default.addObserver(self, selector: #selector(SubscriptionPurchased), name: NSNotification.Name(rawValue: "SubscriptionPurchased"), object: nil)
        
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
        if showTabbar == true {
        self.tabBarController?.tabBar.isHidden = false
            setUpTabController()
            backMenuBtn.setImage(UIImage(named: "menu"), for:.normal)

        }
        else {
            backMenuBtn.setImage(UIImage(named: "back"), for:.normal)

            self.tabBarController?.tabBar.isHidden = true

        }
//        self.getGroupList()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        setUpTabController()
    }
    
    
    @objc func SubscriptionPurchased() {
        self.autheticatePayment(paymentMethodNonce: "")
    }
    
    @IBAction func menuAction(_ sender: Any) {
        if showTabbar == true {
            openSideMenu()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getGroupList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_GROUP_LIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    if json["data"].count > 0 {
                        let subscriptionStatus = json["data"][0]["subscription"].boolValue
                        if subscriptionStatus == false {
                            self.getPlanAPI()
                        } else {
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
                             }

                            DispatchQueue.main.async {
                                if self.inviteGroupArr.count > 0 {
                                    
                                    self.tableView.dataSource = self
                                    self.tableView.delegate = self
                                    self.tableView.reloadData()
                                    self.groupView.isHidden = false
                                    self.subscriptionView.isHidden = true
                                    self.headerGroupTitle.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.NAME) as! String
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
    

    

    
    func getPlanAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_SUBSCRIPTION_PLAN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    self.subscriptionListArr.removeAll()
                    
                    for i in 0..<json["data"].count {
                        let frequency_type =  json["data"][i]["frequency_type"].stringValue
                        let title =  json["data"][i]["title"].stringValue
                        let amount =  json["data"][i]["amount"].stringValue
                        let duration =  json["data"][i]["duration"].stringValue
                        let detail =  json["data"][i]["detail"].stringValue
                        let id =  json["data"][i]["id"].stringValue
                        
                        self.subscriptionListArr.append(subscriptionListStruct.init(frequency_type: frequency_type, title: title, amount: amount, duration: duration, detail: detail, id: id))
                    }
                    
                    DispatchQueue.main.async {
                        if self.subscriptionListArr.count > 0 {
                            
                            self.tblViewSubscription.dataSource = self
                            self.tblViewSubscription.delegate = self
                            self.tblViewSubscription.reloadData()
                            self.groupView.isHidden = true
                            self.subscriptionView.isHidden = false
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
    
    @IBAction func subscriptionPayAction(_ sender: UIButton) {
        let indexPath: IndexPath? = tblViewSubscription.indexPathForRow(at: sender.convert(CGPoint.zero, to: tblViewSubscription))
         let participantObj = self.subscriptionListArr[indexPath!.row]
//
        planId = participantObj.id
        

//        self.getBrainTreeToken()
        if indexPath!.row == 0 {
            IAPService.shared.isSubscriptionPurchased = "monthly"
           // IAPManager.shared.purchaseMyProduct(identifier: planId)

            IAPService.shared.purchase(product: .MonthlySubscription)
        } else {
            IAPService.shared.isSubscriptionPurchased = "annual"
            //IAPManager.shared.purchaseMyProduct(identifier: planId)
            IAPService.shared.purchase(product: .AnnualSubscription)
        }
        
    }
    
    @IBAction func aletCloseAction(_ sender: UIButton) {
        self.alertView.isHidden = true
    }
    
}

extension GroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblViewSubscription {
            return 200
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return self.inviteGroupArr.count
            
        }else{
            return self.subscriptionListArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
            
            let groupListObj = self.inviteGroupArr[indexPath.row]
            cell.cellLbl.text = "Manage \(groupListObj.name)"
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
            
            let subscriptionListObj = self.subscriptionListArr[indexPath.row]
            cell.cellTitleLbl.text = subscriptionListObj.title
            cell.cellDurationLbl.text = subscriptionListObj.duration
            cell.cellFrequencyLbl.text = subscriptionListObj.frequency_type
            cell.amountLbl.text = subscriptionListObj.title == "Monthly APP Subscriptions" ? "£99.99" : "£1099.99"
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.backgroundColor = .white
            
            let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            headerLabel.text = "Your Matches"

            headerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
            headerView.addSubview(headerLabel)
            
            return headerView
            
        }else{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.backgroundColor = .clear
            
            let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            headerLabel.text = "App Subscription Plan List"

            headerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
            headerView.addSubview(headerLabel)
            
            return headerView
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.tableView{
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "Intrinsic Matrix – IM. When the TeamPlayerUK profile questionnaire is taken by participants, it establishes their Intrinsic Matrix - compatibility profile.  The “IM” acquires its value when compared to other members of current or planned teams. The results of these comparisons are used to match participants to the right employers/team leaders and current team members to help create the most compatible teams. The match is not skills or talent based, so, it accelerates hiring decisions, de-risks team building and helps improve productivity, reduces the costs of hiring new staff and minimizes hiring mistakes."
            label.textColor = .gray
            label.font = UIFont(name: "Roboto-Medium", size: 14)
            return label
            
        }else{
            
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return 40
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return 300
            
        }else{
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            let groupListObj = self.inviteGroupArr[indexPath.row]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
            vc.groupId = groupListObj.id
            self.navigationController?.pushViewController(vc, animated: true)
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
            
            let param:[String:Any] = ["id": "\(planId)", "transaction_id": paymentMethodNonce]
            
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.UPDATE_AppSubscriptionPurchase, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.view.makeToast("Payment done successfully.")
                        //show alert, "Please proceed with buying questionaires from "Purchase" tab."
                        
                        let alert = UIAlertController(title: "Next step?", message: "Please proceed with attending questionaires from App Questionaires tab.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            guard let window = UIApplication.shared.delegate?.window else {
                                return
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                            viewController.selectedIndex = 2
                                                    
                            window!.rootViewController = viewController
                            let options: UIView.AnimationOptions = .transitionCrossDissolve
                            let duration: TimeInterval = 0.5
                            UIView.transition(with: window!, duration: duration, options: options, animations: {}, completion:
                                                { completed in
                                window!.makeKeyAndVisible()
                            })
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { action in
                            self.getGroupList()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                   
                    
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
    
}

extension GroupVC : PKPaymentAuthorizationViewControllerDelegate{
    
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
