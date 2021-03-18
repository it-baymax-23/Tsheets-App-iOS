//
//  AdminOverviewViewController.swift
//  wowsheet
//
//  Created by AAA on 7/8/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class AdminOverviewViewController: UIViewController {

    //@IBOutlet weak var progressBar: CircularProgressBar!
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var dayTotalBtn: UIButton!
    @IBOutlet weak var weekTotalBtn: UIButton!
    @IBOutlet weak var dayTotalBtnUnderline: UIView!
    @IBOutlet weak var weekTotalBtnUnderline: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var totalWorkTimeLabel: UILabel!
    @IBOutlet weak var totalHourLabel: UILabel!
    @IBOutlet weak var clockedInOrStartWeekLabel: UILabel!
    @IBOutlet weak var jobOrEndWeekLabel: UILabel!
    @IBOutlet weak var clockedInOrStartWeekLabelValue: UILabel!
    @IBOutlet weak var jobOrEndWeekLabelValue: UILabel!
    
    @IBOutlet weak var todayScheduleView: UIView!
    
    @IBOutlet weak var myWorkView: UIView!
    
    public var percentage: Float!
    
    
    
    let myPreferences = UserDefaults.standard
    let startTimeKey = "startTime"
    let loginStatusKey = "loginStatus"
    let loginUserIdKey = "loginUserId"
    let loginUserNameKey = "loginUserName"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Overview"
        self.drawProfileBtn()
        viewInit()
        
        self.percentage = 0.6
        drawProgressBar()
    }
    
    func viewInit(){
        dayTotalBtnUnderline.isHidden = false
        weekTotalBtnUnderline.isHidden = true
        
        dayTotalBtnUnderline.frame = CGRect(x: 0 , y: 40, width: UIScreen.main.bounds.width / 2, height: 2)
        weekTotalBtnUnderline.frame = CGRect(x: UIScreen.main.bounds.width / 2, y: 40, width: UIScreen.main.bounds.width / 2, height: 2)
        
        dayTotalBtn.frame = CGRect(x: 0 , y: 10, width: UIScreen.main.bounds.width / 2, height: 30)
        weekTotalBtn.frame = CGRect(x: UIScreen.main.bounds.width / 2 , y: 10, width: UIScreen.main.bounds.width / 2, height: 30)
        
        weekTotalBtn.setTitleColor(UIColor.lightGray, for: .normal)
        dayTotalBtn.setTitleColor(UIColor(red: 64/255.0, green: 162/255.0, blue: 255/255.0, alpha: 1), for: .normal)
        
        totalView.layer.borderWidth = 1
        totalView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        todayScheduleView.layer.borderWidth = 1
        todayScheduleView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        myWorkView.layer.borderWidth = 1
        myWorkView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        
        
        clockedInOrStartWeekLabel.text = "Clocked In"
        jobOrEndWeekLabel.text = "Job"
        totalHourLabel.text = "of 8.00 hrs"
        totalHourLabel.sizeToFit()
        
        clockedInOrStartWeekLabel.frame = CGRect(x: 0 , y: 290, width: UIScreen.main.bounds.width / 2, height: 20)
        clockedInOrStartWeekLabel.textAlignment = .center
        jobOrEndWeekLabel.frame = CGRect(x: UIScreen.main.bounds.width / 2 , y: 290, width: UIScreen.main.bounds.width / 2, height: 20)
        jobOrEndWeekLabel.textAlignment = .center
        clockedInOrStartWeekLabelValue.frame = CGRect(x: 0 , y: 320, width: UIScreen.main.bounds.width / 2, height: 20)
        clockedInOrStartWeekLabelValue.textAlignment = .center
        jobOrEndWeekLabelValue.frame = CGRect(x: UIScreen.main.bounds.width / 2 , y: 320, width: UIScreen.main.bounds.width / 2, height: 20)
        jobOrEndWeekLabelValue.textAlignment = .center
        
    }
    
    func drawProfileBtn(){
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
    
    func drawProgressBar(){
        let circularProgress = CircularProgressBar(frame: CGRect(x: 20.0, y: 20.0, width: 160.0, height: 160.0))
        circularProgress.progressColor = UIColor(red: 52.0/255.0, green: 141.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        circularProgress.trackColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1)
        circularProgress.tag = 101
        //circularProgress.center = self.progressBarView.center
        self.progressBarView.addSubview(circularProgress)
        
        //animate progress
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
    }
    
    @objc func animateProgress() {
        let cp = self.progressBarView.viewWithTag(101) as! CircularProgressBar
        cp.setProgressWithAnimation(duration: 1.0, value: self.percentage)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func profileOpen() {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
//        self.present(vc, animated: true, completion: nil)
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC");
        let navController = UINavigationController(rootViewController: myVC!)        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    
    @IBAction func dayTotalBtnClick(_ sender: Any) {
        dayTotalBtnUnderline.isHidden = false
        weekTotalBtnUnderline.isHidden = true
        weekTotalBtn.setTitleColor(UIColor.lightGray, for: .normal)
        dayTotalBtn.setTitleColor(UIColor(red: 64/255.0, green: 162/255.0, blue: 255/255.0, alpha: 1), for: .normal)
        
        clockedInOrStartWeekLabel.text = "Clocked In"
        jobOrEndWeekLabel.text =  "Job"
        totalHourLabel.text = "of 8.00 hrs"
        totalHourLabel.sizeToFit()
        
        
        self.percentage = 0.8
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
    }
    
    
    @IBAction func weekTotalBtnClick(_ sender: Any) {
        dayTotalBtnUnderline.isHidden = true
        weekTotalBtnUnderline.isHidden = false
        weekTotalBtn.setTitleColor(UIColor(red: 64/255.0, green: 162/255.0, blue: 255/255.0, alpha: 1), for: .normal)
        dayTotalBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        clockedInOrStartWeekLabel.text = "Start Week"
        jobOrEndWeekLabel.text =  "End Week"
        totalHourLabel.text = "of 40.00 hrs"
        totalHourLabel.sizeToFit()
        
        self.percentage = 0.4
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
    }
    
}
