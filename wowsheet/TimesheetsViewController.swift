//
//  TimesheetsViewController.swift
//  wowsheet
//
//  Created by AAA on 7/9/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit
import SQLite3

class TimesheetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var timesheetTableView: UITableView!
    
    public var jobNames: [String] = []
    public var totalWorkTimes: [String] = []
    public var dates: [String] = []
    public var startAndEndTimes: [String] = []
    
    public var allTimesheetData = [] as Array<Any>
    
    let myPreferences = UserDefaults.standard
    let startTimeKey = "startTime"
    let loginStatusKey = "loginStatus"
    let loginUserIdKey = "loginUserId"
    let loginUserNameKey = "loginUserName"
    
    public var dataTableDb: OpaquePointer?
    
    var jobList = ["Job 1", "Job 2", "Job 3", "Job 4", "Job 5", "Job 6", "Job 7", "Job 8", "Job 9"]
    var jobIdList = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Timesheets"
        
        self.dataTableDb = self.createOpenDatabase() // create and open database
        
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
        
        
        // show all timesheet
        self.readTimesheetData()
        
        timesheetTableView.dataSource = self
        timesheetTableView.delegate = self
        
        self.timesheetTableView.allowsSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    // refresh when tab click again
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            //self.viewDidLoad()
            self.readTimesheetData()
            self.timesheetTableView.reloadData()
        }
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
    
    func readTimesheetData() {
        allTimesheetData = []
        let queryStatementString = "SELECT * FROM timesheet ORDER BY id DESC;"
        // id, notes, attachment, starttime, endtime, jobid, userid
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.dataTableDb, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                let jobid = sqlite3_column_int(queryStatement, 5)
                let userid = sqlite3_column_int(queryStatement, 6)
                
                let notes = String(cString: queryResultCol1!)
                let attachment = String(cString: queryResultCol2!)
                let starttime = String(cString: queryResultCol3!)
                let endtime = String(cString: queryResultCol4!)
                
                let item = [
                    "id": id,
                    "notes": notes,
                    "attachment" : attachment,
                    "starttime" : starttime,
                    "endtime" : endtime,
                    "jobid" : jobid,
                    "userid" : userid
                    ] as [String : Any]
                allTimesheetData.append(item)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTimesheetData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "workSheetItem") as! TimeCardTableViewCell
        let timesheetRow = allTimesheetData[indexPath.row]
        //let notes = (timesheetRow as AnyObject).value(forKey: "notes") as! String
        //let attachment = (timesheetRow as AnyObject).value(forKey: "attachment") as! String
        let starttime = (timesheetRow as AnyObject).value(forKey: "starttime") as! String
        let endtime = (timesheetRow as AnyObject).value(forKey: "endtime") as! String
        let jobid = (timesheetRow as AnyObject).value(forKey: "jobid") as! Int
        //let userid = (timesheetRow as AnyObject).value(forKey: "userid") as! Int
        
        let jobName = self.getJobNameByJobId(selectedJobId: jobid)
        let totalWorkTime = self.getTotalWorkTime(starttime: self.toDate(dateString: starttime)!, endtime: self.toDate(dateString: endtime)!)
        
        let date = starttime.components(separatedBy: " ")[0]
        let starttime1 = starttime.components(separatedBy: " ")[1]
        let endtime1 = endtime.components(separatedBy: " ")[1]
        let starttimeWithoutSec = self.getTimeWithoutSec(time: starttime1)
        let endtimeWithoutSec = self.getTimeWithoutSec(time: endtime1)
        
        cell.jobNameLabelOutlet.text = jobName
        cell.jobNameLabelOutlet.numberOfLines = 3;
        cell.totalWorkTimeLabelOutlet.text = totalWorkTime
        cell.startAndEndTimeLabelOutlet.text = date
        cell.startAndEndTimeLabelOutlet1.text = starttimeWithoutSec + "-" + endtimeWithoutSec
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "workSheetItem") as! TimeCardTableViewCell
        let timesheetRow = allTimesheetData[indexPath.row]
        let notes = (timesheetRow as AnyObject).value(forKey: "notes") as! String
        //let attachment = (timesheetRow as AnyObject).value(forKey: "attachment") as! String
        let starttime = (timesheetRow as AnyObject).value(forKey: "starttime") as! String
        let endtime = (timesheetRow as AnyObject).value(forKey: "endtime") as! String
        let jobid = (timesheetRow as AnyObject).value(forKey: "jobid") as! Int
        //let userid = (timesheetRow as AnyObject).value(forKey: "userid") as! Int

        let jobName = self.getJobNameByJobId(selectedJobId: jobid)
        let totalWorkTime = self.getTotalWorkTime(starttime: self.toDate(dateString: starttime)!, endtime: self.toDate(dateString: endtime)!)

        let date = starttime.components(separatedBy: " ")[0]
        let starttime1 = starttime.components(separatedBy: " ")[1]
        let endtime1 = endtime.components(separatedBy: " ")[1]
        let starttimeWithoutSec = self.getTimeWithoutSec(time: starttime1)
        let endtimeWithoutSec = self.getTimeWithoutSec(time: endtime1)

        let vc = storyboard?.instantiateViewController(withIdentifier: "timesheetDetailVC") as? TimeSheetDetailViewController
        vc?.startTime = starttimeWithoutSec
        vc?.endTime = endtimeWithoutSec
        vc?.totalTime = totalWorkTime
        vc?.jobName = jobName
        vc?.notes = notes
        vc?.date = date
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getTimeWithoutSec(time: String) -> String {
        return time.components(separatedBy: ":")[0] + ":" + time.components(separatedBy: ":")[1]
    }
    
    func getJobNameByJobId(selectedJobId : Int) -> String {
        var jobName: String = ""
        for index in 0 ... (jobIdList.count - 1) {
            if jobIdList[index] == selectedJobId {
                jobName = jobList[index]
            }
        }
        
        return jobName
    }
    
    func getTotalWorkTime(starttime: Date, endtime: Date) -> String {
        let time = Int(endtime.timeIntervalSince1970 - starttime.timeIntervalSince1970)
        
        var timeString: String = ""
        let hour: Int = time / 3600
        let hourRemain: Int = time - hour * 3600
        let min: Int = hourRemain / 60
        if time > 3600 {
            timeString = String(hour) + "h " + String(min) + "m"
        } else if time > 60 {
            timeString = String(min) + "m"
        } else {
            timeString = "1m"
        }
        
        return timeString
    }
    
    func toDate(dateString: String)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        
        return date
    }
    
    // Create database
    func createOpenDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("wowsheets.sqlite")

        // open database
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "create table if not exists timesheet (id integer primary key autoincrement, notes text, attachment text, starttime datetime, endtime datetime, jobid integer, userid integer)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        return db
    }

}
