//
//  SelectJobViewController.swift
//  wowsheet
//
//  Created by AAA on 7/18/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class SelectJobViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var jobNameListTableView: UITableView!
    
    public var jobList = ["Job 1 Time tracking mobile app development using swift in iOS.", "Job 2", "Job 3", "Job 4", "Job 5", "Job 6", "Job 7", "Job 8", "Job 9"]
    public var jobIdList = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select a Job"
        let addNewJobBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewJobOpen))
        self.navigationItem.rightBarButtonItem = addNewJobBtn
        
        jobNameListTableView.delegate = self
        jobNameListTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func addNewJobOpen() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectJobTableViewCell") as! SelectJobTableViewCell
        cell.jobNameLabel.text = self.jobList[indexPath.row]
        cell.jobNameLabel.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width - 20, height: 40)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "addScheduleVC") as! AddScheduleViewController
        myVC.jobName = self.jobList[indexPath.row]
        myVC.jobId = self.jobIdList[indexPath.row]
        self.navigationController?.pushViewController(myVC, animated: true)
    }

}
