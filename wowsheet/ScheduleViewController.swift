//
//  ScheduleViewController.swift
//  wowsheet
//
//  Created by AAA on 7/9/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scheduleTableView: UITableView!
    
    let myPreferences = UserDefaults.standard
    let startTimeKey = "startTime"
    let loginStatusKey = "loginStatus"
    let loginUserIdKey = "loginUserId"
    let loginUserNameKey = "loginUserName"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Schedule"
        self.drawProfileBtn()
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    func drawProfileBtn() {
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
    }
    
    @objc func profileOpen() {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC");
        let navController = UINavigationController(rootViewController: myVC!)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addScheduleBtnClick(_ sender: Any) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "addScheduleVC");
        let navController = UINavigationController(rootViewController: myVC!)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleTableViewCell") as! ScheduleTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
