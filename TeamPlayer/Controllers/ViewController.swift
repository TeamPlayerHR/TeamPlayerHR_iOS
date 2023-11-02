//
//  ViewController.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 27/06/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //newUserButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        self.imageView.roundRadius(options: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func onTapSignIn(_ sender: Any) {
        isDemo = false
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onTapNewUser(_ sender: Any) {
        isDemo = false
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewUserVC") as! NewUserVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onTapDemoRequest(_ sender: Any) {
        isDemo = true
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
//        UIApplication.shared.delegate!.window!!.rootViewController = viewController
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DemoVC") as! DemoVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)

    }
}

