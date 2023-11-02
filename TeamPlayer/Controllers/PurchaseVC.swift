//
//  PurchaseVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 04/08/21.
//

import UIKit
import Braintree
import BraintreeDropIn
import StoreKit

class PurchaseVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, UIActionSheetDelegate {
    
//    enum Product: String, CaseIterable {
//        case questionnaire: "com.ChwatechSolutions.questionnaire"
//    }
    
   
    

    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var newUserPlan: UIView!
    @IBOutlet weak var backMenuBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var pptView: UIView!
    @IBOutlet weak var numberOfQuestionaireTxt: UITextField!
    
    var clientToken = String()
    var orderId = String()
    var braintreeClient: BTAPIClient?
    var totalAmount : Double = Double()
   // var totalAmount = 0.1
    var purchasePlansArray = [purchasePlansStruct]()
    var newUserPlanAmount : Double = Double()
    var newUserPlanId = String()
    var isFrom = "New User Plan"
    var questionaireCount = Int()
    var showTabbar:Bool? = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getDemoPlanAPI()
        self.getPurchasePlansApi()
        self.pptView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
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
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.IS_FULL_QUESTIONAIRE) as! String == "true"  {
            self.planLbl.isHidden = true
            self.newUserPlan.isHidden = true
        } else {
            self.planLbl.isHidden = false
            self.newUserPlan.isHidden = false
//            self.planLbl.isHidden = true
//            self.newUserPlan.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionairePurchased), name: NSNotification.Name(rawValue: "QuestionairePurchased"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newUserPlanPurchased), name: NSNotification.Name(rawValue: "newUserPlanPurchased"), object: nil)
        
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
    
    
    @objc func QuestionairePurchased() {
        self.updateDemoPaymentAPI()
    }
    
    @objc func newUserPlanPurchased() {
        self.updateNewUserPlanAPI()
    }
    
    @IBAction func purchaseFullQuestionAction(_ sender: UIButton) {
        if let url = URL(string: "https://dev.teamplayerhr.com/purchase") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        if showTabbar == true {
            openSideMenu()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let oProduct = response.products.first {
            debugPrint("Hey Product is Available")
            debugPrint(oProduct.price)
            debugPrint(oProduct.localizedPrice)
            self.purchase(aproduct: oProduct)
        } else {
            debugPrint("Hey Product is not Available")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                debugPrint("customer is in the process of purchase.")
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.updateDemoPaymentAPI()
                debugPrint("Purchased.")
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                debugPrint("Transaction Failed.")
            case .restored:
                debugPrint("Restored")
            case .deferred:
                debugPrint("Deferred")
            default:
                break
            }
        }
    }
    
    func purchase(aproduct: SKProduct) {
        let payment = SKPayment(product: aproduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    @IBAction func paymentAction(_ sender: Any) {
        if self.numberOfQuestionaireTxt.text!.isEmpty {
            self.view.makeToast("Please fill the number of Questionaire you want.")
            return
        }
        self.isFrom = "App Questionnaire"
//        self.totalAmount = self.totalAmount * Double(self.numberOfQuestionaireTxt.text!)!
//        self.getBrainTreeToken()
        
        // ============
        if SKPaymentQueue.canMakePayments() {
            let set: Set<String> = ["com.ChwatechSolutions.questionnaire1"]
            let productRequest = SKProductsRequest(productIdentifiers: set)
//            productRequest.delegate = self
//            productRequest.start()
        } else {
            self.view.makeToast("Could not do Payment")
            return
        }
        
         
        
        switch self.questionaireCount {
        case 1:
            IAPService.shared.purchase(product: .Questionnaire_1)
        case 5:
            IAPService.shared.purchase(product: .Questionnaire_5)
        case 10:
            IAPService.shared.purchase(product: .Questionnaire_10)
        case 15:
            IAPService.shared.purchase(product: .Questionnaire_15)
        case 25:
            IAPService.shared.purchase(product: .Questionnaire_25)
        case 50:
            IAPService.shared.purchase(product: .Questionnaire_50)
        case 75:
            IAPService.shared.purchase(product: .Questionnaire_75)
        case 100:
            IAPService.shared.purchase(product: .Questionnaire_100)
        case 500:
            IAPService.shared.purchase(product: .Questionnaire_500)
        default:
            break
        }
    }
    
    @IBAction func newUserPayAction(_ sender: UIButton) {
//        self.totalAmount = self.newUserPlanAmount
//        self.getBrainTreeToken()
        
        IAPService.shared.isSubscriptionPurchased = "newUserPlan"
        IAPService.shared.purchase(product: .NewUserPlan)
    }
    
    
    func getDemoPlanAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.DEMO_PLAN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    for i in 0..<json["data"].count {
                        if json["data"].count > 0 {
                            let amount =  json["data"][i]["amount"].stringValue
                            self.totalAmount = Double(amount) ?? 0.0
                            planId = json["data"][0]["id"].stringValue
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
    
    func updateDemoPaymentAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
//            let param:[String:Any] = ["id": planId, "number_survay": self.numberOfQuestionaireTxt.text!, "data": []]
            let param:[String:Any] = ["id": planId, "number_survay": self.questionaireCount, "data": []]
            
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.UPDATE_DEMO_PAYMENT, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.showAlert()
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
    
    func updateNewUserPlanAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = ["id": self.newUserPlanId, "number_survay": "1", "data": []]
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.UPDATE_NEW_USER_PLAN_PAYMENT, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
//                    self.showAlert()
                    self.view.makeToast("Payment updated successfully.")
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
    
    func showAlert() {
        let alert = UIAlertController(title: "Payment Done", message: "Please attend app questionaire.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in

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
            
        }))
        self.present(alert, animated: true, completion: nil)

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
        request.paypalDisabled = false
        
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
            
            let param:[String:Any] = ["chargeAmount": "\(self.totalAmount)", "nonce": paymentMethodNonce]
            
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CREATE_PURCHASE, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
//                    self.view.makeToast("Payment done successfully.")
                    self.isFrom == "New User Plan" ? self.updateNewUserPlanAPI() : self.updateDemoPaymentAPI()
//                    self.updateDemoPaymentAPI()
                    
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
    
    func getPurchasePlansApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_PURCHASE_PLANS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.purchasePlansArray.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let id =  json["data"][i]["id"].stringValue
                        let name =  json["data"][i]["name"].stringValue
                        let number_survay =  json["data"][i]["number_survay"].stringValue
                        let amount =  json["data"][i]["amount"].stringValue
                        let plan_type =  json["data"][i]["plan_type"].stringValue
                        self.newUserPlanAmount = Double(amount) ?? 0.0
                        self.newUserPlanId = id
                        
                        self.purchasePlansArray.append(purchasePlansStruct.init(id: id, name: name, number_survay: number_survay, amount: amount, plan_type: plan_type))
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
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
    
    @IBAction func questionaireListAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Questionaire", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Buy 1 Questionaire at $0.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 1
            self.numberOfQuestionaireTxt.text = "1 Questionaire at $0.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 5 Questionaire at $4.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 5
            self.numberOfQuestionaireTxt.text = "5 Questionaire at $4.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 10 Questionaire at $9.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 10
            self.numberOfQuestionaireTxt.text = "10 Questionaire at $9.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 15 Questionaire at $14.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 15
            self.numberOfQuestionaireTxt.text = "15 Questionaire at $14.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 25 Questionaire at $24.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 25
            self.numberOfQuestionaireTxt.text = "25 Questionaire at $24.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 50 Questionaire at $49.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 50
            self.numberOfQuestionaireTxt.text = "50 Questionaire at $49.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 75 Questionaire at $74.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 75
            self.numberOfQuestionaireTxt.text = "75 Questionaire at $74.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 100 Questionaire at $99.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 100
            self.numberOfQuestionaireTxt.text = "100 Questionaire at $99.99"
        }))
        
        alert.addAction(UIAlertAction(title: "Buy 500 Questionaire at $499.99", style: .default , handler:{ (UIAlertAction)in
            self.questionaireCount = 500
            self.numberOfQuestionaireTxt.text = "500 Questionaire at $499.99"
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
    
    
}

extension PurchaseVC : PKPaymentAuthorizationViewControllerDelegate{
    
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

extension PurchaseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchasePlansArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath) as! PurchaseCell
        
        let purchaseListObj = purchasePlansArray[indexPath.row]
        cell.cellLbl.text = "\(purchaseListObj.name)"
        
        
        return cell
    }
}
