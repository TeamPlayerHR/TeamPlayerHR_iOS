//
//  HowItWorksVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 01/07/21.
//

import UIKit

class HowItWorksVC: UIViewController {

    @IBOutlet weak var contentLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contentLbl.text = "The Team PlayerHR is simple to complete. You will be asked a series of multiple choice questions, select an answer. You should answer as fast as you can because questions are time based and will fade out after a period of time.\n\nJust be as honest as you can be and trust your first response. Once completed you'll be issued an \("IM") Intrinsic Matrix. To be compare to other IM's for compatibly."
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func menuAction(_ sender: Any) {
      //  openSideMenu()
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func notificationAction(_ sender: Any) {
    }
    
}
