//
//  IAPService.swift
//  TeamPlayer
//
//  Created by ChawTech Solutions on 16/08/22.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    override init() {
        super.init()
        //Other initialization here.
    }
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    var isNewPurchase = false
    var isrestored = false
    var isSubscriptionPurchased = ""
    #if DEBUG
    let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    #else
    let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
    #endif
    func getProducts() {
        SKPaymentQueue.default().add(self)

        let products: Set = [IAPProducts.Questionnaire_1.rawValue, IAPProducts.Questionnaire_5.rawValue, IAPProducts.Questionnaire_10.rawValue, IAPProducts.Questionnaire_15.rawValue,IAPProducts.Questionnaire_25.rawValue, IAPProducts.Questionnaire_50.rawValue, IAPProducts.Questionnaire_75.rawValue, IAPProducts.Questionnaire_100.rawValue, IAPProducts.Questionnaire_500.rawValue, IAPProducts.MonthlySubscription.rawValue, IAPProducts.AnnualSubscription.rawValue, IAPProducts.PayPerClick.rawValue, IAPProducts.NewUserPlan.rawValue]
        //let products: Set = ["testing_course"]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func getCourseProducts(id:String) {
        let products: Set = [id]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func videoPurchase(product: String) {
        isNewPurchase = true
        guard let productToPurchase = products.filter({ $0.productIdentifier == product }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
        
    }
    
    func getVideoProducts(id:String) {
        let products: Set = [id]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }

    func purchase(product: IAPProducts) {
        isNewPurchase = true
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func coursePurchase(product: String) {
        isNewPurchase = true
        guard let productToPurchase = products.filter({ $0.productIdentifier == product }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
        
    }
    
    func restorePurchases() {
        print("restore purchases")
        paymentQueue.restoreCompletedTransactions()
    
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        for product in response.products {
            print(product)
            print(product.price)
            print(product.priceLocale)
            print(product.localizedPrice)
            
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            
            switch transaction.transactionState {
            case .purchasing: break
            default: queue.finishTransaction(transaction)
            }
        }
    }
    
   
    
}

extension IAPService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            
            switch transaction.transactionState {
            case .purchasing:
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .purchased:
                print("Purchased on Date:- ", transaction.transactionDate!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.isSubscriptionPurchased == "monthly" || self.isSubscriptionPurchased == "annual" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubscriptionPurchased"), object: nil)
                    } else if self.isSubscriptionPurchased == "payPerClick"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payPerClickPurchased"), object: nil)
                    } else if self.isSubscriptionPurchased == "newUserPlan"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newUserPlanPurchased"), object: nil)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QuestionairePurchased"), object: nil)
                    }
                    
                }
               
                paymentQueue.finishTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            default:
                
                queue.finishTransaction(transaction)
                break
            }
        }
    }
    func receiptValidation() {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd/MM/yyyy"
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        if recieptString == nil {
            restorePurchases()
            isrestored = true
            return
        }
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : "6cb4f2ea9c37411e82a042cfca71110c" as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                
                do {
                    //if Reachability.isConnectedToNetwork() {
//                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                        print(jsonResponse)
//
//                        if let date1 = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
//                            print(date1)//Expiry Date
//                            if let date2 = self?.getPurchaseDateFromResponse(jsonResponse as! NSDictionary) {
//                                print(date2)
//                            }
//                        }
//                    }else{
//
//                    }
                } catch let parseError {
                    print(parseError)
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
        }
    }
    
    func daysCount(startDateTime: Date, endDateTime:Date) -> Int {
        let calendar = NSCalendar.current as NSCalendar
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDateTime)
        let date2 = calendar.startOfDay(for: endDateTime)
        
        let flags = NSCalendar.Unit.day
        let components = calendar.components(flags, from: date1, to: date2, options: [])
        
        return components.day!
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            var planPrice = 0.0
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            
            if let isTrialPeriod = lastReceipt["is_trial_period"] {
                print(isTrialPeriod)
                if isNewPurchase {
                    
                }
            }
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
    
    func getPurchaseDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["purchase_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
    
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}
extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Okay", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
