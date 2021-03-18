//
//  MoreViewController.swift
//  wowsheet
//
//  Created by AAA on 7/9/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    let myPreferences = UserDefaults.standard
    let startTimeKey = "startTime"
    let loginStatusKey = "loginStatus"
    let loginUserIdKey = "loginUserId"
    let loginUserNameKey = "loginUserName"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "More"
        
        let userName = myPreferences.object(forKey: self.loginUserNameKey) as! String
        let firstCharacterOfUserName = String(userName.prefix(2))
        
        let button = UIButton()
        button.frame = CGRect(x:0, y:0, width:35, height:35)
        button.backgroundColor = UIColor(red: 147/255.0, green: 218/255.0, blue: 116/255.0, alpha: 1)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.setTitle(firstCharacterOfUserName, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action:#selector(self.profileOpen), for:.touchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.navigationItem.leftBarButtonItem = barButton
        
        // Do any additional setup after loading the view.
    }
    
    @objc func profileOpen() {
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC");
        let navController = UINavigationController(rootViewController: myVC!)
        navController.modalTransitionStyle = .partialCurl
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
