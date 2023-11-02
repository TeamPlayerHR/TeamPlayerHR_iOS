//
//  QuestionaireVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 19/07/21.
//

import UIKit

class QuestionaireVC: UIViewController {
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var minuteLbl: UILabel!
    @IBOutlet weak var quesLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var demoQuestionArr = [demoQuestionStruct]()
    var demoAnswersArr = [demoAnswerStruct]()
    var count = 0
    var singleAnswer = ""
    var multipleAnswers:NSMutableArray = []
    var seconds = 86401
    var timer = Timer()
    var groupId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.getQuestionList()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = tableView.tableHeaderView else {return}
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
//        openSideMenu()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
    @IBAction func submitAction(_ sender: Any) {
        //        self.count += 1
        //        self.setQuestionTxt(self.count)
        //        let myIndexPath = IndexPath(row: 1, section: 0)
        //        self.tableView.reloadRows(at: [myIndexPath], with: .fade)
        
        let quesObj = self.demoQuestionArr[self.count]
//        let ansObj = self.demoAnswersArr[self.count]
        let ansObj = self.demoQuestionArr[self.count]
        var param:[String:Any] = [:]
        
        if quesObj.maxanswers == "1" {
            
            if self.singleAnswer.isEmpty {
                self.view.makeToast("Please select your answer.")
                return
            }
            param = [ "question_id": ansObj.questionid,"answer_given":self.singleAnswer,"maxanswers":quesObj.maxanswers]
        } else {
            let selectedAnsArr = quesObj.answers
            let maxAnswerInt = Int(quesObj.maxanswers)
            print(selectedAnsArr)
            if checkMaxLimitOfSelection(selectedAnsArr) > maxAnswerInt! {
                self.view.makeToast("Only \(maxAnswerInt!) Max selections allowed.")
                return
            } else if checkMaxLimitOfSelection(selectedAnsArr) < maxAnswerInt! {
                self.view.makeToast("Sleect minimum \(maxAnswerInt!) answers.")
                return
            } else if checkMaxLimitOfSelection(selectedAnsArr) == 0 {
                self.view.makeToast("Please select your answer.")
                return
            }
            
//            let ms = NSMutableArray(array: makeParams(selectedAnsArr))
//            print(ms)
            
            let ms =  makeParams(selectedAnsArr)
            param = [ "question_id": ansObj.questionid,"answer_given":ms,"maxanswers":quesObj.maxanswers]
            
          //  param = [ "question_id": ansObj.questionid,"answer_given":ms,"maxanswers":quesObj.maxanswers]
            
        }
        
        print(param)
        self.saveQuestionApiCall(param)
        
    }
    
    func getQuestionList() {
        if Reachability.isConnectedToNetwork() {
//            showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_QUESTION_LIST, successBlock: { (json) in
                print(json)
//                hideAllProgressOnView(appDelegateInstance.window!)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.demoQuestionArr.removeAll()
                    
                    for i in 0..<json["data"]["questions"].count {
                        let answer_saved =  json["data"]["questions"][i]["answer_saved"].boolValue
                        let timelimit =  json["data"]["questions"][i]["timelimit"].stringValue
                        let question =  json["data"]["questions"][i]["question"].stringValue
                        let maxanswers =  json["data"]["questions"][i]["maxanswers"].stringValue
                        let subpart = json["data"]["questions"][i]["subpart"].stringValue
                        let questionid =  json["data"]["questions"][i]["id"].stringValue
                        
                        self.demoAnswersArr.removeAll()
                        for j in 0..<json["data"]["questions"][i]["answers"].count {
                            let answer = json["data"]["questions"][i]["answers"][j]["answer"].stringValue
                            let answerId = json["data"]["questions"][i]["answers"][j]["answer_id"].stringValue
                            let questionid = json["data"]["questions"][i]["answers"][j]["questionid"].stringValue
                            let sortorder = json["data"]["questions"][i]["answers"][j]["sortorder"].stringValue
                            let image = json["data"]["questions"][i]["answers"][j]["image"].stringValue
                            let created_at = json["data"]["questions"][i]["answers"][j]["created_at"].stringValue
                            let status = json["data"]["questions"][i]["answers"][j]["status"].boolValue
                            
                            
                            let updated_at = json["data"]["questions"][i]["answers"][j]["updated_at"].stringValue
                            
                            self.demoAnswersArr.append(demoAnswerStruct.init(answerId: answerId, sortorder: sortorder, image:image, created_at: created_at, answer: answer, questionid: questionid, status: status, updated_at: updated_at))
                        }
                        
                        self.seconds = Int(timelimit)!
                        if !answer_saved {
                            self.demoQuestionArr.append(demoQuestionStruct.init(question: question, maxanswers: maxanswers, timelimit: timelimit, subpart: subpart, answers: self.demoAnswersArr, questionid: questionid))
                        }
                        
                    }
                    
                    if self.demoQuestionArr.count == 0 {
                        self.setScore()

                    }
                    
                    DispatchQueue.main.async {
                        if self.demoQuestionArr.count > 0 {
                            self.setQuestionTxt(0)
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.emptyView.isHidden = true
                            self.tableView.isHidden = false
                            self.timeView.isHidden = false
                            self.tableView.reloadData()
                        } else {
                            self.emptyView.isHidden = false
                            self.tableView.isHidden = true
                            self.timeView.isHidden = true
                        }
                    }
                    
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
//                hideAllProgressOnView(appDelegateInstance.window!)
                hideAllProgressOnView(self.view)
            })
            
        }else{
//            hideAllProgressOnView(appDelegateInstance.window!)
            hideAllProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func setScore() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "test": "2","group_id":"\(self.groupId)"]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SET_SCORE, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    
//                    UserDefaults.standard.setValue(json["data"]["token"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
//                    UserDefaults.standard.setValue(json["data"]["role"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ROLE)
                    
                    self.view.makeToast(json["message"].stringValue)
                    DispatchQueue.main.async {
                        self.emptyView.isHidden = false
                        self.tableView.isHidden = true
                        self.timeView.isHidden = true
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
    
    func setQuestionTxt(_ count: Int) {
        let quesObj = self.demoQuestionArr[count]
        self.quesLbl.text = "Q.\(quesObj.subpart). \(quesObj.question.html2String)"
        //self.quesLbl.text = quesObj.question.html2String
        runTimer()
    }
    
    func saveQuestionApiCall(_ param:[String:Any]) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                //                fcmKey = ""
                fcmKey = "abcdef"
            }
            
            timer.invalidate()
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SAVE_QUESTION, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    self.singleAnswer = ""
                    if self.demoQuestionArr.count > (self.count + 1) {
                        self.count += 1
                        let timelimit = self.demoQuestionArr[self.count].timelimit
                        self.seconds = Int(timelimit)!
                        self.setQuestionTxt(self.count)
                        self.tableView.reloadData()
//                        let myIndexPath = IndexPath(row: 1, section: 0)
//                        self.tableView.reloadRows(at: [myIndexPath], with: .fade)
                    } else {
                        //set score api hit
//                        self.setScore()
                        self.count = 0
                        self.getQuestionList()
//                        let serialQueue = DispatchQueue(label: "SerialQueue")
//
//                                serialQueue.async {
//                                    //first task
//                                    self.setScore()
//
//                                }
//
//                                serialQueue.async {
//                                    //second task
//                                    self.getQuestionList()
//                                }
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
    
    //Mark: timer setup
    func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(updateTimer)),
                                     userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        if seconds < 1 {
            timer.invalidate()
            if self.demoQuestionArr.count > (self.count + 1) {
                self.count += 1
                let timelimit = self.demoQuestionArr[self.count].timelimit
                self.seconds = Int(timelimit)!
                self.setQuestionTxt(self.count)
                self.tableView.reloadData()
            } else {
                self.count = 0
                self.getQuestionList()
            }
            
        } else {
            seconds -= 1
            //timerLabel.setText(timeString(time: TimeInterval(seconds)))
            let timeStr = (timeString(time: TimeInterval(seconds)))
            self.minuteLbl.text = timeStr.2
            self.secondLbl.text = timeStr.3
        }
    }
    
    func timeString(time:TimeInterval) -> (String, String, String,String) {
        //        let days = Int(time) / 86400
        //        let hours = Int(time) / 3600
        //        let minutes = Int(time) / 60 % 60
        //        let seconds = Int(time) % 60
        
        
        let days = (Int(time) / 86400)
        let hours = ((Int(time) % 86400) / 3600)
        let minutes = ((Int(time) % 3600) / 60)
        let seconds = (Int(time) % 3600) % 60
        
        let daysStr = String(format:"%02i", days)
        let hoursStr = String(format:"%02i", hours)
        let minutsStr = String(format:"%02i",  minutes)
        let secondsStr = String(format:"%02i", seconds)
        return (daysStr,hoursStr,minutsStr,secondsStr)
    }
    
    func checkMaxLimitOfSelection(_ ansArr: [demoAnswerStruct]) -> Int {
        var count = 0
        for i in 0..<ansArr.count {
            if ansArr[i].status {
                count += 1
            }
        }
        return count
    }
    
    func makeParams(_ ansArr: [demoAnswerStruct]) -> [Any] {
           var paramArr =  [[String:Any]]()
           for i in 0..<ansArr.count {
               let dict:[String:Any] = ["answer_id":ansArr[i].answerId,"sortorder":ansArr[i].sortorder,"image":ansArr[i].image,"created_at":ansArr[i].created_at,"answer":ansArr[i].answer,"questionid":ansArr[i].questionid,"status":ansArr[i].status,"updated_at":ansArr[i].updated_at]
               paramArr.append(dict)
           }
           print(paramArr)
           return paramArr
       }
    
    @IBAction func inviteAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
        viewController.selectedIndex = 1
                                
        window!.rootViewController = viewController
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.5
        UIView.transition(with: window!, duration: duration, options: options, animations: {}, completion:
                            { completed in
            window!.makeKeyAndVisible()
        })

    }
    
//    func makeParams(_ ansArr: [demoAnswerStruct]) -> NSMutableArray {
//        let paramArr: NSMutableArray = NSMutableArray()
//        for i in 0..<ansArr.count {
//            var dict:[String:Any] = [:]
//            dict["answerId"] = ansArr[i].answerId
//            dict["sortorder"] = ansArr[i].sortorder
//            dict["image"] = ansArr[i].image
//            dict["created_at"] = ansArr[i].created_at
//            dict["answer"] = ansArr[i].answer
//            dict["questionid"] = ansArr[i].questionid
//            dict["status"] = ansArr[i].status
//            dict["updated_at"] = ansArr[i].updated_at
//
//            paramArr.add(dict)
//        }
//        return paramArr
//    }
    
}

extension QuestionaireVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demoQuestionArr[self.count].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let quesObj = self.demoQuestionArr[self.count]
        if quesObj.maxanswers == "1" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioAnswerCell", for: indexPath) as! RadioAnswerCell
            
            let answerObj = self.demoQuestionArr[self.count].answers[indexPath.row]
            cell.cellLbl.text = answerObj.answer
            
            if answerObj.answerId == self.singleAnswer {
                cell.cellImg.image = UIImage.init(named: "radio_check")
            } else {
                cell.cellImg.image = UIImage.init(named: "radio_uncheck")
            }
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxAnswerCell", for: indexPath) as! CheckboxAnswerCell
            
            let answerObj = self.demoQuestionArr[self.count].answers[indexPath.row]
            cell.cellLbl.text = answerObj.answer
            
            if answerObj.status {
                cell.cellImg.image = UIImage.init(named: "checked")
            } else {
                cell.cellImg.image = UIImage.init(named: "uncheck")
            }
            
            //            if answerObj.answerId == self.singleAnswer {
            //                cell.cellImg.image = UIImage.init(named: "checked")
            //            } else {
            //                cell.cellImg.image = UIImage.init(named: "uncheck")
            //            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quesObj = self.demoQuestionArr[self.count]
        if quesObj.maxanswers == "1" {
            let selectedAns = quesObj.answers[indexPath.row]
            self.singleAnswer = selectedAns.answerId
        } else {
            let maxAnswerInt = Int(quesObj.maxanswers)
            var selectedAnsArr = quesObj.answers
            
            var selectedAns = quesObj.answers[indexPath.row]
            selectedAns.status = !selectedAns.status
            selectedAnsArr[indexPath.row] = selectedAns
            self.demoQuestionArr[self.count].answers = selectedAnsArr
            
        }
        self.tableView.reloadData()
    }
    
    
}
