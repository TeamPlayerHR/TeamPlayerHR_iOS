//
//  TermsOfUseVC.swift
//  TeamPlayer
//
//  Created by ChawTech Solutions on 13/03/23.
//

import UIKit
import WebKit

class TermsOfUseVC: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var urlStr: String = "https://teamplayerhr.com/terms-and-conditions"
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .init(x: 20, y: 70, width: 335, height: 577), configuration: webConfiguration)
        webView = WKWebView(frame: .init(x: 20, y: 70, width: 335, height: 577-100), configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dsa()
    }
    

    public func dsa() {
        
        let url : NSString = self.urlStr as NSString
        let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!

        let requestObj = URLRequest(url: searchURL as URL)
        webView.load(requestObj)

        
//        webView.navigationDelegate = self
    }

    func webViewDidStartLoad(_ : WKWebView) {
        showProgressOnView(appDelegateInstance.window!)
    }

    func webViewDidFinishLoad(_ : WKWebView) {
        hideAllProgressOnView(appDelegateInstance.window!)
    }


}
