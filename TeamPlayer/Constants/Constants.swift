//
//  Constants.swift
//  TeamLink
//
//  Created by chawtech solutions on 3/01/18.
//  Copyright © 2018 chawtech solutions. All rights reserved.

import UIKit
import MBProgressHUD
import AVFoundation
import SwiftyJSON
import SDWebImage
import SkyFloatingLabelTextField
import Toast_Swift

let regularFont = UIFont.systemFont(ofSize: 16)
let boldFont = UIFont.boldSystemFont(ofSize: 16)
let IS_IPHONE_5 = UIScreen.main.bounds.width == 320
let IS_IPHONE_6 = UIScreen.main.bounds.width == 375
let IS_IPHONE_6P = UIScreen.main.bounds.width == 414
let IS_IPAD = UIScreen.main.bounds.width >= 768.0
let IS_IPAD_Mini = UIScreen.main.bounds.width == 768.0
let IS_IPAD_Pro = UIScreen.main.bounds.width == 834.0
let IS_IPAD_Pro12 = UIScreen.main.bounds.width == 1024.0
let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate

let deviceType = "iOS"
let kPasswordMinimumLength = 6
let kPasswordMaximumLength = 15
let kUserFullNameMaximumLength = 56
let kPhoneNumberMaximumLength = 10
let kMessageMinimumLength = 25
let kMessageMaximumLength = 250
let selectionColor = UIColor(red: 36/255.0, green: 98/255.0, blue: 126/255.0, alpha: 1.0)
let kLostInternetConnectivityAlertString = "Your internet connection seems to be lost." as String
let kPasswordLengthAlertString = NSString(format:"The Password should consist at least %d characters.",kPasswordMinimumLength) as String
let kPasswordWhiteSpaceAlertString = "The Password should not contain any whitespaces." as String
let kUnequalPasswordsAlertString = "Both Passwords do not match." as String
let kEqualPasswordsAlertString = "Old & New Password are same." as String
let kMessageTextViewPlaceholderString = "Write your experience..." as String
let kMesssageLengthAlertString = NSString(format:"The Message should consist at least %d-%d characters.",kMessageMinimumLength,kMessageMaximumLength) as String
let kUnexpectedErrorAlertString = "An unexpected error has occurred. Please try again." as String
let kNoDataFoundAlertString = "Sorry! No data found." as String
let kChooseAnyOneOpttionAlertString = "Please choose any one option" as String
let kSignUpCaseAlertString = "Password should contains at least 1 Upper Case, 1 Lower Case, 1 number & 1 special character."
var countryArr = [String]()
//http://35.160.227.253/SaharaGo/File/
//let BASE_URL = "http://35.160.227.253:8081"
//let FLAG_BASE_URL = "http://35.160.227.253/SaharaGo/Flag"
//let FILE_BASE_URL = "http://35.160.227.253/SaharaGo/File"

//let BASE_URL = "https://admin.teamplayerhr.com/api"
let BASE_URL = "https://superadmin.teamplayerhr.com/api"

let FLAG_BASE_URL = "http://34.220.107.44/SaharaGo/Flag"
let FILE_BASE_URL = "https://admin.teamplayerhr.com/storage/app/public"


let BANNER_BASE_URL = "http://35.160.227.253/SaharaGo/Banner/"
let TRUST_BASE_URL = "http://35.160.227.253:8081"
let IMAGE_URL = ""
let GOOGLE_API_KEY = "AIzaSyDVB3k-rFkbVioA_rSpdOlWqSb1RrgjERo  "  //"AIzaSyDwBRVfP3aoCIZ77fhT1Gj8ntbKoL01qPE"
let X_API_KEY = "AOmAfXgEOBiziaIZfynXNuUnnNvWnjjcoP1Qpd8S"

var fcmKey:String = "dudaaaa"
var isDemo = false
var inviteGroupArr = [inviteGroupStruct]()
var userType = ""
var inviteeName: [String] = [String]()
var planId = String()

struct PROJECT_URL {
    
    static let GET_COUNTRIES = "/countries"
    static let GET_SECTOR = "/sector"
    static let GET_OCCUPATION = "/occupation"
    static let GET_STATE = "/states"
    static let GET_CITIES = "/cities"
    static let LOGIN = "/user/login"
    static let SIGNUP = "/user/register"
    static let SIGNUP_COMPANY = "/user/register_org"
    static let FORGET_PASSWORD = "/user/forgot_password"
    static let PROFILE = "/user/profile"
    static let UPDATE_PROFILE = "/user/profile/update"
    static let CONTACT_US = "/user/contact"
    static let LOGOUT = "/user/logout"
    static let FAQ = "/faq"
    static let GET_QUESTION_LIST = "/demo/questions"
    static let SAVE_QUESTION = "/demo/questions/save_answer"
    static let GET_GROUP_LIST = "/demo/questionnaire"
    static let GET_GROUP_DETAIL = "/demo/questionnaire/detail?id="
    static let GET_GROUP_JOINED = "/demo/group_joined"
    static let GET_TEAMS = "/demo/get_subgroup"
    static let SEND_INVITATION = "/demo/send_invite"
    static let SEND_MULTIPLE_INVITATION = "/demo/send_multiple_invite"
    static let CREATE_TEAM = "/demo/add_subgroup"
    static let ADD_TO_TEAM = "/demo/add_user_subgroup"
    static let SEND_REMINDER = "/demo/send_reminder"
    static let CHANGE_USER_TYPE = "/demo/team_usertype"
    static let GET_BRAINTREE_TOKEN = "/braintree/getclienttoken"
    static let CREATE_PURCHASE = "/braintree/createpurchase"
    static let SHOW_INVITEES = "/demo/questionnaire/invitee_list"
    static let DEMO_REQUEST = "/user/demo_request"
    static let DEMO_PLAN = "/demo/plan"
    static let NEWS = "/news"
    static let DELETE_INVITEE = "/demo/delete_invite"
    static let GET_SUBSCRIPTION_PLAN = "/user/app/subscription"
    
    static let GET_AppQuestionnairePurchase_HISTORY = "/user/appQuestionnairePurchase"
    static let GET_SubscriptionPurchase_HISTORY = "/user/subscriptionPurchase"
    static let GET_AppPPCPurchase_HISTORY = "/user/appPPCPurchase"
    static let GET_RenewalPurchase_HISTORY = "/user/renewalPurchase"
    static let GET_FullQuestionnairePurchase_HISTORY = "/user/fullQuestionnairePurchase"
    static let GET_AppSubscriptionPurchase_HISTORY = "/user/appSubscriptionPurchase"
    static let UPDATE_AppSubscriptionPurchase = "/user/updateAppSubscriptionPayment"
    static let UPDATE_PPC_PAYMENT = "/user/updatePPCPayment"
    static let GEt_AppQuestionnairePurchase_AMOUNT = "/user/appQuestionnairePurchase"
    static let SET_SCORE = "/demo/questions/set_score"
    static let UPDATE_DEMO_PAYMENT = "/user/updateDemoPayment"
    static let GET_INVITATION = "/demo/invitation"
    static let JOIN_GROUP = "/demo/join_group"
    static let GET_PURCHASE_PLANS = "/user/new_user_plan"
    static let UPDATE_NEW_USER_PLAN_PAYMENT = "/user/updateNewUserPayment"
    static let DELETE_ACCOUNT = "/user/delete_account"
    
    
}

struct CONDITION_KEYS {
    static let EMAIL_OTP = "emailOtp"
    static let MOBILE_OTP = "mobileOtp"
}

struct USER_DEFAULTS_KEYS {
    
    static let VENDOR_SIGNUP_TOKEN = "vendorSignupToken"
    static let USER_ROLE = "role"
    static let NAME = "name"
    static let IS_FULL_QUESTIONAIRE = "isFullQuestionaireDone"
    

    
    
    static let VENDOR_SIGNUP_OTP_ID = "vendorSignupOtpId"
    static let USER_TYPE = "userType"
    static let CART_ID = "cartId"
    static let USER_ID = "userId"
    static let CART_PRODUCTS = "cartProducts"
    static let COUNTRY_COLOR_CODE = "countryColorCode"
    static let SELECTED_COUNTRY = "selectedCountry"
    static let SELECTED_FLAG = "selectedFlag"
    
    
    static let LOGIN_TOKEN = "loginToken"
    static let IS_LOGIN = "isLogin"
    static let FCM_KEY = "fcmKey"
}
struct NOTIFICATION_KEYS
{
    static let PROFILE_ADD_UPDATE = "profileaddupdate"
    static let EVENT_ADD_UPDATE = "eventaddupdate"
}

////MARK:- Logout User
//func logoutUser2() {
//    UserDefaults.standard.set(false, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
//    flushUserDefaults()
//    clearImageCache()
//    initialiseAppWithController(LoginViewController())
//}
//func logoutUser()
//{
//    sideMenuViewController.hideLeftViewAnimated()
//    UserDefaults.standard.set(false, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
//    flushUserDefaults()
//    clearImageCache()
//    let rootController = (sideMenuViewController.rootViewController as! UINavigationController)
//    removeController(rootController: rootController)
//    (sideMenuViewController.rootViewController as! UINavigationController).pushViewController(LoginViewController(), animated: false)
//}

func removeController(rootController:UINavigationController)
{
    for controller in rootController.viewControllers
    {
        if  controller is UITabBarController
        {
            
        }
        else
        {
            controller.removeFromParent()
        }
    }
}
//MARK:- Remove User Defaults
func flushUserDefaults() {
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
}

//MARK:- Alert Methods
func showMessageAlert(message:String) {
    UIAlertController.showInfoAlertWithTitle("Alert", message: message , buttonTitle: "Okay")
}

func showNoDataFoundAlert() {
    UIAlertController.showInfoAlertWithTitle("", message: kNoDataFoundAlertString , buttonTitle: "Okay")
}

func showLostInternetConnectivityAlert() {
    UIAlertController.showInfoAlertWithTitle("Uh Oh!", message: kLostInternetConnectivityAlertString , buttonTitle: "Okay")
}

func showNonNumericInputErrorAlert(_ fieldName : String) {
    UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"The %@ can only be numeric.",fieldName), buttonTitle: "Okay")
}

func showPasswordLengthAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kPasswordLengthAlertString, buttonTitle: "Okay")
}

func showPasswordWhiteSpaceAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kPasswordWhiteSpaceAlertString, buttonTitle: "Okay")
}

func showPasswordUnEqualAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kUnequalPasswordsAlertString, buttonTitle: "Okay")
}

func showPasswordEqualAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kEqualPasswordsAlertString, buttonTitle: "Okay")
}

func showInvalidInputAlert(_ fieldName : String) {
    UIAlertController.showInfoAlertWithTitle("Alert", message: String(format:"Please enter a valid %@.",fieldName), buttonTitle: "Okay")
}

func showMessageLengthAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kMesssageLengthAlertString , buttonTitle: "Okay")
}

func showSignUpCharacterCaseAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kSignUpCaseAlertString , buttonTitle: "Okay")
}
func showChooseAnyOneOptionAlert() {
    UIAlertController.showInfoAlertWithTitle("", message: kChooseAnyOneOpttionAlertString , buttonTitle: "Okay")
}

//MARK:- MBProgressHUD Methods
func showProgressOnView(_ view:UIView) {
    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
    loadingNotification.mode = MBProgressHUDMode.indeterminate
    loadingNotification.label.text = "Loading.."
}

func hideProgressOnView(_ view:UIView) {
    MBProgressHUD.hide(for: view, animated: true)
}

func hideAllProgressOnView(_ view:UIView) {
//    MBProgressHUD.hideAllHUDs(for: view, animated: true)
    MBProgressHUD.hide(for: view, animated: true)
}

//MARK:-document directory realted method
public func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
public func getImageUrl() -> URL? {
    let url = URL(fileURLWithPath: (getDirectoryPath() as NSString).appendingPathComponent("temp.jpeg"))
    return url
}

public func saveImageDocumentDirectory(usedImage:UIImage, nameStr:String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(nameStr)
    let imageData = usedImage.jpegData(compressionQuality: 0.5)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}
public func saveImageDocumentDirectory(usedImage:UIImage)
{
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("temp.jpeg")
    let imageData = usedImage.jpegData(compressionQuality: 0.5)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}

func deleteDirectory(name:String){
    
    let fileManager = FileManager.default
    do {
        let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for url in fileURLs {
            try fileManager.removeItem(at: url)
        }
    } catch {
        print(error)
    }
}

//MARK:- Clear SDWebImage Cache
//func clearImageCache() {
//    SDImageCache.shared().clearDisk()
//    SDImageCache.shared().clearMemory()
//}

//MARK:- Fetch Device Width
func fetchDeviceWidth() -> CGFloat {
    if IS_IPHONE_5 {
        return 320
    } else if IS_IPHONE_6 {
        return 375
    } else if IS_IPHONE_6P{
        return 414
    }else if IS_IPAD_Mini {
        return 768
    } else if IS_IPAD_Pro {
        return 834.0
    }
    else if IS_IPAD_Pro12 {
        return 760
    }
    else {
        return 1024
    }
}
//MARK:- Fetch Device Height

func fetchDeviceHeight() -> CGFloat {
    if IS_IPHONE_5 {
        return 568
    } else if IS_IPHONE_6 {
        return 667
    } else if IS_IPHONE_6P {
        return 736
    } else if IS_IPAD_Mini {
        return 1024
    } else if IS_IPAD_Pro  {
        return 1112
    } else if IS_IPAD_Pro12  {
        return 1366
    }else {
        return 1366
    }
    
}

public func disableEditinginTextFieldWithTagArr(tagList:Array<Int>,targetView:UIView)
{
    for index in tagList
    {
        let txtField =  targetView.viewWithTag(index) as! UITextField
        txtField.isEnabled = false
    }
}


public func isTimeLyingBetween(target:String,from:String,to:String) -> Bool
{
    var isTimeLying = false
    let formatter = DateFormatter()
    //formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    let fromTime = formatter.date(from: from)
    let toTime = formatter.date(from: to)
    let targetTime = formatter.date(from: target)
    
    if (fromTime?.compare(targetTime!) == .orderedAscending) && (targetTime?.compare(toTime!) == .orderedAscending)
    {
        isTimeLying = true
    }
    return isTimeLying
    
}

public func getTimeInAmPm()-> String?
{
    let formatter = DateFormatter()
    // formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    // formatter.dateFormat = "h:mm a yyyy-MM-dd HH:mm:ss"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    let dateString = formatter.string(from: Date())
    print("dateInAmPm : \(dateString)")
    return dateString
}

public func getDayName()->String?
{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let today = formatter.string(from: date)
    
    if let todayDate = formatter.date(from: today)
    {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            print("Error fetching days")
            return "Day"
        }
    } else {
        return nil
    }
}
func getCountryCodeAndName()
{
    var countryDictionary = ["AF":"93", "AL":"355", "DZ":"213","AS":"1", "AD":"376", "AO":"244", "AI":"1","AG":"1","AR":"54","AM":"374","AW":"297","AU":"61","AT":"43","AZ":"994","BS":"1","BH":"973","BD":"880","BB":"1","BY":"375","BE":"32","BZ":"501","BJ":"229","BM":"1","BT":"975","BA":"387","BW":"267","BR":"55","IO":"246","BG":"359","BF":"226","BI":"257","KH":"855","CM":"237","CA":"1","CV":"238","KY":"345","CF":"236","TD":"235","CL":"56","CN":"86","CX":"61","CO":"57","KM":"269","CG":"242","CK":"682","CR":"506","HR":"385","CU":"53","CY":"537","CZ":"420","DK":"45","DJ":"253","DM":"1","DO":"1","EC":"593","EG":"20","SV":"503","GQ":"240","ER":"291","EE":"372","ET":"251","FO":"298","FJ":"679","FI":"358","FR":"33","GF":"594","PF":"689","GA":"241","GM":"220","GE":"995","DE":"49","GH":"233","GI":"350","GR":"30","GL":"299","GD":"1","GP":"590","GU":"1","GT":"502","GN":"224","GW":"245","GY":"595","HT":"509","HN":"504","HU":"36","IS":"354","IN":"91","ID":"62","IQ":"964","IE":"353","IL":"972","IT":"39","JM":"1","JP":"81","JO":"962","KZ":"77","KE":"254","KI":"686","KW":"965","KG":"996","LV":"371","LB":"961","LS":"266","LR":"231","LI":"423","LT":"370","LU":"352","MG":"261","MW":"265","MY":"60","MV":"960","ML":"223","MT":"356","MH":"692","MQ":"596","MR":"222","MU":"230","YT":"262","MX":"52","MC":"377","MN":"976","ME":"382","MS":"1","MA":"212","MM":"95","NA":"264","NR":"674","NP":"977","NL":"31","AN":"599","NC":"687","NZ":"64","NI":"505","NE":"227","NG":"234","NU":"683","NF":"672","MP":"1","NO":"47","OM":"968","PK":"92","PW":"680","PA":"507","PG":"675","PY":"595","PE":"51","PH":"63","PL":"48","PT":"351","PR":"1","QA":"974","RO":"40","RW":"250","WS":"685","SM":"378","SA":"966","SN":"221","RS":"381","SC":"248","SL":"232","SG":"65","SK":"421","SI":"386","SB":"677","ZA":"27","GS":"500","ES":"34","LK":"94","SD":"249","SR":"597","SZ":"268","SE":"46","CH":"41","TJ":"992","TH":"66","TG":"228","TK":"690","TO":"676","TT":"1","TN":"216","TR":"90","TM":"993","TC":"1","TV":"688","UG":"256","UA":"380","AE":"971","GB":"44","US":"1", "UY":"598","UZ":"998", "VU":"678", "WF":"681","YE":"967","ZM":"260","ZW":"263","BO":"591","BN":"673","CC":"61","CD":"243","CI":"225","FK":"500","GG":"44","VA":"379","HK":"852","IR":"98","IM":"44","JE":"44","KP":"850","KR":"82","LA":"856","LY":"218","MO":"853","MK":"389","FM":"691","MD":"373","MZ":"258","PS":"970","PN":"872","RE":"262","RU":"7","BL":"590","SH":"290","KN":"1","LC":"1","MF":"590","PM":"508","VC":"1","ST":"239","SO":"252","SJ":"47","SY":"963","TW":"886","TZ":"255","TL":"670","VE":"58","VN":"84","VG":"284","VI":"340"]
    
    
    let allKeys = countryDictionary.keys
    for key in allKeys
    {
        let combindStr = "\(key)(+\(countryDictionary[key]!))"
        countryArr.append(combindStr)
    }
    
    print(countryDictionary.count)
}
//func openCountriesPickerAction(sender: UITextField)
//{
//    let greenColor = sender.backgroundColor
//
//    let greenAppearance = YBTextPickerAppearanceManager.init(
//        pickerTitle         : "Select Country",
//        titleFont           : boldFont,
//        titleTextColor      : .white,
//        titleBackground     : greenColor,
//        searchBarFont       : regularFont,
//        searchBarPlaceholder: "Search Country Name",
//        closeButtonTitle    : "Cancel",
//        closeButtonColor    : .darkGray,
//        closeButtonFont     : regularFont,
//        doneButtonTitle     : "Okay",
//        doneButtonColor     : greenColor,
//        doneButtonFont      : boldFont,
//        checkMarkPosition   : .Left,
//        itemCheckedImage    : UIImage(named:"green_ic_checked"),
//        itemUncheckedImage  : UIImage(named:"green_ic_unchecked"),
//        itemColor           : .black,
//        itemFont            : regularFont
//    )
//
//    let countries = countryArr
//    let picker = YBTextPicker.init(with: countries, appearance: greenAppearance,
//                                   onCompletion: { (selectedIndexes, selectedValues) in
//                                    if selectedValues.count > 0
//                                    {
//                                        let selectedValue =  selectedValues.first!
//                                        sender.text = selectedValue
//                                        var values = [String]()
//                                        for index in selectedIndexes{
//                                            values.append(countries[index])
//                                        }
//
//                                        print(values)
//
//                                    }
//                                    else
//                                    {
//                                        //                                            self.btnCountyPicker.setTitle("Select Countries", for: .normal)
//                                    }
//                                   },
//                                   onCancel: {
//                                    print("Cancelled")
//                                   }
//    )
//
//    picker.allowMultipleSelection = false
//
//    picker.show(withAnimation: .Fade)
//}

func getDayNameFromDate(dateStr:String) -> String {
    let formatter = DateFormatter()
    //formatter.dateFormat = "dd/MM/yyyy"
    formatter.dateFormat = "MM/dd/yyyy"
    let date = formatter.date(from: dateStr)
    formatter.dateFormat = "EEEE"
    let dayName = formatter.string(from: date!)
    return dayName
}

func getFormattedDateStr(dateStr:String) -> String
{
    let formatter = DateFormatter()
    //    formatter.dateFormat = "dd/MM/yyyy"
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let date = formatter.date(from: dateStr)
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "dd MMM,yyyy HH:mm:ss"
    
    let strdate = formatter.string(from: date!)
    return strdate
}

extension UILabel {

    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

//func chnageBtnColour() {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//    if let viewControllers = appDelegate.window?.rootViewController?.presentedViewController
//    {
//        // Array of all viewcontroller even after presented
//    }
//    else if let viewControllers = appDelegate.window?.rootViewController?.children
//    {
//        // Array of all viewcontroller after push
//        for i in view.subviews {
//            if i is UILabel {
//                let newLbl = i as? UILabel
//                if newLbl?.tag == 1 {
//                    /// Write your code
//                }
//            }
//        }
//    }
//}
//
//func listSubviewsOf(_ view: UIView?) {
//
//    // Get the subviews of the view
//    let subviews = view?.subviews
//
//    for subview in subviews ?? [] {
//
//        // Do what you want to do with the subview
//        print("\(subview)")
//
//        // List the subviews of subview
//        listSubviewsOf(subview)
//    }
//}

//func changeBtnColour(_ button: UIButton) {
//    
//    guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
//    guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
//    let myStringArr = rgba.components(separatedBy: ",")
//    button.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
//    
//}
