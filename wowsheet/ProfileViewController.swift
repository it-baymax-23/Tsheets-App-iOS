//
//  ProfileViewController.swift
//  wowsheet
//
//  Created by AAA on 7/9/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"

//        let button = UIButton()
//        button.setTitle("X", for: .normal)
//        button.setTitleColor(UIColor(red: 47/255.0, green: 120/255.0, blue: 255/255.0, alpha: 1), for: .normal)
//        button.addTarget(self, action:#selector(self.profileClose), for:.touchUpInside)
//        let barButton = UIBarButtonItem()
//        barButton.customView = button
//        self.navigationItem.leftBarButtonItem = barButton
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.profileClose))
        self.navigationItem.leftBarButtonItem = cancelBtn
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func profileClose(){
        self.dismiss(animated: true, completion: nil)
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
