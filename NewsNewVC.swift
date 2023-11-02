//
//  NewsNewVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 14/12/21.
//  

import UIKit

class NewsNewVC: UIViewController {
    
    var newsArray = [newsListStruct]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getNewsApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func menuAction(_ sender: Any) {
       // openSideMenu()
        self.navigationController?.popViewController(animated: true)
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getNewsApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.NEWS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.newsArray.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let title =  json["data"][i]["title"].stringValue
                        let id =  json["data"][i]["id"].stringValue
                        let description =  json["data"][i]["content"].stringValue
                        let feature_image =  json["data"][i]["feature_image"].stringValue
                        
                        self.newsArray.append(newsListStruct.init(id: id, title: title, description: description, feature_image: feature_image))
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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

extension NewsNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        let newsListObj = newsArray[indexPath.row]
        cell.cellLbl.text = newsListObj.title
        cell.cellSubLbl.text = newsListObj.description.html2String
        cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(newsListObj.feature_image)"), placeholderImage: UIImage(named: "news_img"))
        
        return cell
    }
    
    
}
