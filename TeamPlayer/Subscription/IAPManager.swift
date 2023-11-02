//
//  IAPManager.swift
//  TeamPlayer
//
//  Created by Chawtech on 09/10/23.
//

import Foundation

import Foundation
import BRYXBanner
import StoreKit

//MARK: - SubscriptionType
enum SubscriptionType{
    case purchase
    case restore
}

//MARK: - IAPManagerDelegate
protocol IAPManagerDelegate: AnyObject {
    func fetched(products: [IAProduct])
    func itemPurchased(params: [String: Any])
}

//MARK: - IAPManagerProductStatus
enum IAPManagerProductStatus: String {
    case disabled = "Purchases are disabled in your device!"
    case restored = "You've successfully restored your purchase!"
    case purchased = "You've successfully bought this item!"
    case noProducts = "No products are available"
    case purchasing = "Purchasing is in progress"
    case deved = "Purchasing is in progress and requires action"
}

////MARK: - IAProduct
struct IAProduct {
    let description: String
    let title: String
    let price : NSDecimalNumber
    let identifier: String
    let priceSymbol: String
    let priceWithCurrency: String
}

////MARK: - IAPManager
class IAPManager: NSObject {
    static let shared = IAPManager()
    fileprivate var productsRequest = SKProductsRequest()
    public var iapProducts = [SKProduct]()
    var showLoader = false
    var currentPurchaseStatus: IAPManagerProductStatus?
    weak var delegate: IAPManagerDelegate?
    var shouldRequestServer = true
    var currentPurchaseIdentifier: String?
    var currentSubscriptionType:SubscriptionType = .purchase
    static let monthlySubscriptionIdentifier = "com.ChwatechSolutions.monthlySubscription"

    //MARK : this is used to show loader

//    func //(flag: Bool) {
//        self.blockScreenViewStart(flag: flag)
//    }

    func displayBanner(title:String) {
        let banner = Banner(title: title, subtitle: "", backgroundColor: UIColor(red:225.0/255.0, green:73.0/255.0, blue:57.5/255.0, alpha:1.000))
      //  banner.dismissesOnTap = true
        banner.show(duration: 0.5)
    }



    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    private override init()
    {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func redeemCode(){
        if #available(iOS 14.0, *) {
            SKPaymentQueue.default().presentCodeRedemptionSheet()
        } else {
            // Fallback on earlier versions
        }
    }
    //MARK: - for purchasing subscription first time
    func purchaseMyProduct(identifier: String){

        if iapProducts.count == 0 {
            currentPurchaseStatus = .noProducts
            //MARK: - no product available
            return
        }

        //MARK: - purchasing If canMakePurchases() return true value
        if self.canMakePurchases() {
            currentSubscriptionType = .purchase
            currentPurchaseIdentifier = identifier
            guard let product = iapProducts.first(where: {$0.productIdentifier == identifier}) else{

                //DisplayBanner.show(title: "Invalid Purchase", type: .failure)
                displayBanner(title: "Invalid Purchase")

                return
            }
            //Loader.show()
            ////(flag: true)

            shouldRequestServer = true
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
        } else {
            currentPurchaseStatus = .noProducts
            displayBanner(title: "You can not make purchase.")
          //  DisplayBanner.show(title: "You can not make purchase.", type: .failure)

        }
    }

    //MARK: - if already purchased subcription and want to restore same subscription in same device or other device
    func restorePurchase(){
      //  Loader.show()
        //(flag: true)

        shouldRequestServer = true
        currentSubscriptionType = .restore
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    //MARK: - fetchAvailableProducts (fetch already purchased product when app run) calling from app delegate
    func fetchAvailableProducts(showLoader: Bool){
        self.showLoader = showLoader
        if iapProducts.count > 0{
            return
        }
        if showLoader {
           // Loader.show()
            //(flag: true)
        }
        productsRequest = SKProductsRequest(productIdentifiers: Set(arrayLiteral: IAPManager.monthlySubscriptionIdentifier))

        productsRequest.delegate = self
        productsRequest.start()
    }

    //MARK: - getProducts (get already purchased product when come on subscription's VC)
    func getProducts() -> [IAProduct]{
        var products = [IAProduct]()
        for product in iapProducts{
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product.priceLocale
            let price1Str = numberFormatter.string(from: product.price)
            print(product.localizedDescription + "\nfor just \(price1Str!)")
            products.append(IAProduct(description: product.description, title: product.localizedTitle, price: product.price, identifier: product.productIdentifier, priceSymbol: price1Str ?? "error", priceWithCurrency:  price1Str ?? "error"))
        }
        return products
    }

    func removeObserver(){
        SKPaymentQueue.default().remove(self)
    }
}

extension IAPManager: SKProductsRequestDelegate{
    func request(_ request: SKRequest, didFailWithError error: Error) {
       // Loader.hide()
        //(flag: false)
        print("didFailWithError \(error.localizedDescription)")
    }
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        print(response.invalidProductIdentifiers)
        print(response.products.first?.description as Any)

       // Loader.hide()
        //(flag: false)

        if (response.products.count > 0) {
            self.iapProducts = response.products
            let pro = self.getProducts()
            DispatchQueue.main.async {[weak self] in
               // guard let self = self else{return}
                self?.delegate?.fetched(products: pro)
            }

        }else {
            self.currentPurchaseStatus = .noProducts
            print("No product available.")
        }
    }

}
extension IAPManager: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                // Loader.hide()
                //(flag: false)
                
                itemPurchasedSuccessfully(identifier: transaction.payment.productIdentifier, transaction: transaction)
            case .failed:
                print("failed")
                
                //  Loader.hide()
                //(flag: false)
                
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // Loader.hide()
                //(flag: false)
                
                print("restored")
                // printReceiptData()
                itemPurchasedSuccessfully(identifier: transaction.payment.productIdentifier, transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing :
                print("purchasing")
            case .deferred :
                print("deferred")
            @unknown default:
                //  Loader.hide()
                //(flag: false)
                
                
                print("unknown")
            }
            if let _ = transaction.error {
                displayBanner(title: "Can't connect to iTunes store")
                
                //  DisplayBanner.show(title: "Can't connect to iTunes store",type: .failure)
            }
        }
    }
    
    func printReceiptData() {
        guard let receiptFileURL = Bundle.main.appStoreReceiptURL else{return}
        let receiptData = try? Data(contentsOf: receiptFileURL)
        
        //let recieptString = receiptData?.base64EncodedString(options: .endLineWithCarriageReturn)
        if let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
            print("printReceiptData:- \(recieptString)\n")
        }
    }
    
    private func itemPurchasedSuccessfully(identifier:String,transaction:SKPaymentTransaction){
        if !shouldRequestServer {
            print("itemPurchasedSuccessfully attampted to request server")
            return
        }
        shouldRequestServer = false
        guard let product = getProducts().first(where: {$0.identifier == identifier}) else{
            // DisplayBanner.show(title: "Invalid identifier.")
            return
        }
        
        print("itemPurchasedSuccessfully \(identifier)")
        var params = [String: Any]()
        
        if identifier == IAPManager.monthlySubscriptionIdentifier{
            params["productId"] = identifier
        }
        //params["password"] = "2dcfea3919fa4c49a4e18afee72fb2bc"
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                print(receiptData)
                
                let receiptString = receiptData.base64EncodedString(options: .endLineWithCarriageReturn)
                params["purchaseToken"] = receiptString
                params["deviceType"] = "IOS"
                if currentSubscriptionType == .restore{
                    params["isRestoring"] = true
                }
                
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.itemPurchased(params: params)
                }
                
                print("Great Product Purchased and params are :- \(params)")
            }
            catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
            }
        }
        
        
        func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
            // Loader.hide()
            //(flag: false)
            
            if queue.transactions.count > 0 {
                // DisplayBanner.show(title: "Purchase restored successfully",type: .success)
              //  displayBanner(title: "Purchase restored successfully")
                
                print("Purchase restored successfully")
            }
            else {
                
                displayBanner(title: "There is no purchase to restore")
                //DisplayBanner.show(title: "There is no purchase to restore",type: .failure)
                print("There is no purchase to restore")
                
            }
        }
        func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
            displayBanner(title: error.localizedDescription)
            //  DisplayBanner.show(title: error.localizedDescription,type: .failure)
            //  Loader.hide()
            //(flag: false)
            
        }
    }
}
