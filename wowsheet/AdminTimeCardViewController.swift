//
//  AdminTimeCardViewController.swift
//  wowsheet
//
//  Created by AAA on 7/8/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit
import SQLite3

class AdminTimeCardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITabBarControllerDelegate {
    

    @IBOutlet weak var dayTotalViewOutlet: UIView!
    @IBOutlet weak var startTimeViewOutlet: UIView!
    @IBOutlet weak var dayTotalString: UILabel!
    @IBOutlet weak var statusString: UILabel!
    @IBOutlet weak var startTimeString: UILabel!
    @IBOutlet weak var noteString: UITextField!
    
    @IBOutlet weak var clockOutBtnOutlet: UIButton!
    @IBOutlet weak var switchBtnOutlet: UIButton!
    @IBOutlet weak var clockInBtnOutlet: UIButton!
    
    @IBOutlet weak var dayTotalViewInOutlet: UIView!
    @IBOutlet weak var noteStringLabel: UILabel!
    @IBOutlet weak var dayTotalStringInOutlet: UILabel!
    @IBOutlet weak var workTimeStringInOutlet: UILabel!
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var jobInputString: UITextField!
    @IBOutlet weak var jobSelectDropdown: UIPickerView!
    
    public var clockInCheck = false
    public var totalWorkTime: Int = 0
    public var workTimer: Timer?
    public var startTimeUpdateTimer: Timer?
    public var startTime: Date?
    
    public var notesString: String = ""
    
    public var selectedJobId: Int = 0
    
    public var switchCheck: Int = 0
    
    public var dataTableDb: OpaquePointer?
    
    let myPreferences = UserDefaults.standard
    let startTimeKey = "startTime"
    let loginStatusKey = "loginStatus"
    let loginUserIdKey = "loginUserId"
    let loginUserNameKey = "loginUserName"
    
    var jobList = ["Job 1", "Job 2", "Job 3", "Job 4", "Job 5", "Job 6", "Job 7", "Job 8", "Job 9"]
    var jobIdList = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    public var attachmentImagearray = [UIImage(named: "attachments.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Time Card"
        
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
        
        dayTotalViewOutlet.layer.borderWidth = 1
        dayTotalViewOutlet.layer.cornerRadius = 2
        dayTotalViewInOutlet.layer.cornerRadius = 2
        dayTotalViewOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        startTimeViewOutlet.layer.borderWidth = 1
        startTimeViewOutlet.layer.cornerRadius = 2
        startTimeViewOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        noteString.layer.borderWidth = 1
        noteString.layer.cornerRadius = 2
        noteString.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        jobInputString.layer.borderWidth = 1
        jobInputString.layer.cornerRadius = 2
        jobInputString.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        jobSelectDropdown.layer.borderWidth = 1
        jobSelectDropdown.layer.cornerRadius = 2
        jobSelectDropdown.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        if(clockInCheck == false) {
            clockOutBtnOutlet.isHidden = true
            switchBtnOutlet.isHidden = true
            clockInBtnOutlet.isHidden = false
            dayTotalViewInOutlet.isHidden = true
            dayTotalViewOutlet.isHidden = false
            
            dayTotalViewOutlet.isHidden = false
            dayTotalViewInOutlet.isHidden = true
            
            attachmentCollectionView.isHidden = true
            attachmentLabel.isHidden = true
            
            noteString.isHidden = true
            noteStringLabel.isHidden = true
            
            jobLabel.isHidden = false
            jobInputString.isHidden = false
            
            
        } else {
            clockOutBtnOutlet.isHidden = false
            switchBtnOutlet.isHidden = false
            clockInBtnOutlet.isHidden = true
            dayTotalViewInOutlet.isHidden = false
            dayTotalViewOutlet.isHidden = true
            
            dayTotalViewOutlet.isHidden = true
            dayTotalViewInOutlet.isHidden = false
            
            attachmentCollectionView.isHidden = false
            attachmentLabel.isHidden = false
            
            noteString.isHidden = false
            noteStringLabel.isHidden = false
            
            jobLabel.isHidden = true
            jobInputString.isHidden = true
            jobSelectDropdown.isHidden = true
        }
        
        // to display the start time with preference
        if clockInCheck == false {
            let startTimeStringFormat = self.getCurrentTimeWithFormat(Date())
            startTimeString.text = startTimeStringFormat
            
            let totalWorkTimeString :String = self.getTotalWorkTimeString(time: 0)
            workTimeStringInOutlet.text = totalWorkTimeString
            
            startTimeUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimeUpdate), userInfo: nil, repeats: true)
        } else {
            let startTimeView: Date = myPreferences.object(forKey: startTimeKey) as! Date
            let startTimeStringFormat = self.getCurrentTimeWithFormat(startTimeView)
            startTimeString.text = startTimeStringFormat
            
            if switchCheck == 1 {
                totalWorkTime = 0
                self.updateWorkingTime()
                workTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateWorkingTime), userInfo: nil, repeats: true)
                switchCheck = 0
                noteString.text = notesString
                jobInputString.text = self.getJobNameByJobId(selectedJobId: selectedJobId)
            } else if switchCheck == 2 {
                self.updateWorkingTime()
                workTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateWorkingTime), userInfo: nil, repeats: true)
                noteString.text = notesString
                switchCheck = 0
            }
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
    
    @objc func profileOpen() {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func startTimeUpdate(){
        let startTimeStringFormat = self.getCurrentTimeWithFormat(Date())
        startTimeString.text = startTimeStringFormat
    }

    
    @IBAction func clockInBtn(_ sender: Any) {
        if self.selectedJobId == 0 {
            let alert = UIAlertController(title: "", message: "Please select one job and go on.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            clockInCheck = true
            clockOutBtnOutlet.isHidden = false
            switchBtnOutlet.isHidden = false
            clockInBtnOutlet.isHidden = true
            dayTotalViewInOutlet.isHidden = false
            dayTotalViewOutlet.isHidden = true
            
            dayTotalViewOutlet.isHidden = true
            dayTotalViewInOutlet.isHidden = false
            
            attachmentCollectionView.isHidden = false
            attachmentLabel.isHidden = false
            
            noteString.isHidden = false
            noteStringLabel.isHidden = false
            noteString.text = ""
            
            jobLabel.isHidden = true
            jobInputString.isHidden = true
            jobSelectDropdown.isHidden = true
            
            workTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateWorkingTime), userInfo: nil, repeats: true)
            
            // to display the start time
            let currentDate = Date()
            let startTimeStringFormat = self.getCurrentTimeWithFormat(currentDate)
            startTimeString.text = startTimeStringFormat
            
            startTimeUpdateTimer?.invalidate()
            
            // to save the start time with preference
            myPreferences.set(currentDate, forKey: startTimeKey)
//            let didSave = myPreferences.synchronize()
//            if !didSave { }
        }
    }
    
    @objc func getCurrentTimeWithFormat(_ date: Date) -> String {
        let calendar = Calendar.current
        
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        var strDay = String(year) + "/" + String(month) + "/" + String(day)
        if currentYear == year && currentMonth == month && currentDay == day {
            strDay = "Today,"
        }
        let strHour = String(hour)
        var strMinutes = String(minutes)
        
        if minutes < 10 {
            strMinutes = "0" + String(minutes)
        }
        let str: String = strDay + " " + strHour + ":" + strMinutes
        return str
    }
    
    @objc func updateWorkingTime(){
        let startTimeFromPreference: Date = myPreferences.object(forKey: startTimeKey) as! Date
        let currentTime = Date()
        
        let diffSec = Int(currentTime.timeIntervalSince1970 - startTimeFromPreference.timeIntervalSince1970)
        if diffSec > totalWorkTime {
            totalWorkTime = diffSec
        }
        totalWorkTime += 1
        
        let totalWorkTimeString :String = self.getTotalWorkTimeString(time: totalWorkTime)
        workTimeStringInOutlet.text = totalWorkTimeString
        
        print(totalWorkTime)
    }
    
    @objc func getTotalWorkTimeString(time: Int) -> String {
        var timeString: String = ""
        let hour: Int = time / 3600
        let hourRemain: Int = time - hour * 3600
        let min: Int = hourRemain / 60
        let sec = hourRemain - min * 60
        if(time > 3600){
            timeString = String(hour) + "h " + String(min) + "m " + String(sec) + "s"
        } else {
            timeString = String(min) + "m " + String(sec) + "s"
        }
        
        return timeString
    }
    
    @IBAction func clockOutBtn(_ sender: Any) {
        clockInCheck = false
        clockOutBtnOutlet.isHidden = true
        switchBtnOutlet.isHidden = true
        clockInBtnOutlet.isHidden = false
        dayTotalViewInOutlet.isHidden = true
        dayTotalViewOutlet.isHidden = false
        
        dayTotalViewOutlet.isHidden = false
        dayTotalViewInOutlet.isHidden = true
        
        attachmentCollectionView.isHidden = true
        attachmentLabel.isHidden = true
        
        noteString.isHidden = true
        noteStringLabel.isHidden = true
        
        jobLabel.isHidden = false
        jobInputString.isHidden = false
        
        let startTimeStringFormat = self.getCurrentTimeWithFormat(Date())
        startTimeString.text = startTimeStringFormat
        
        let totalWorkTimeString :String = self.getTotalWorkTimeString(time: 0)
        workTimeStringInOutlet.text = totalWorkTimeString
        
        workTimer?.invalidate()
        startTimeUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimeUpdate), userInfo: nil, repeats: true)
        
        self.notesString = noteString.text!
        
        // save my time card
        if totalWorkTime > 10 {
            totalWorkTime = 0
            //self.saveMyTimeCard()                 // save the time card on the server
            self.saveMyTimeCardOnLocalDatabase()  // save the time card on the local database
        }
        
        jobInputString.text = ""
        self.selectedJobId = 0
    }
    
    func saveMyTimeCard(){
        
        let userid = myPreferences.integer(forKey: self.loginUserIdKey)
        let jobid = self.selectedJobId
        let notes = noteString.text!
        
        // starttime
        let startTimeFromPreference: Date = myPreferences.object(forKey: startTimeKey) as! Date
        let starttime = startTimeFromPreference.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        // endtime
        let endtime = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        print(starttime)
        print(endtime)
        print(notes)
        print(jobid)
        
        myTimecardUploadRequest(userid: userid, jobid: jobid, notes: notes, starttime: starttime, endtime: endtime, attachmentImagearray: attachmentImagearray as! Array<UIImage>)
        
    }
    
    func saveMyTimeCardOnLocalDatabase() {
        
        let userid = myPreferences.integer(forKey: self.loginUserIdKey)
        let jobid = self.selectedJobId
        let notes = noteString.text!
        let attachment = ""
        // starttime
        let startTimeFromPreference: Date = myPreferences.object(forKey: startTimeKey) as! Date
        let starttime = startTimeFromPreference.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        // endtime
        let endtime = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        print(starttime)
        print(endtime)
        print(notes)
        print(jobid)
        
        let queryString = "INSERT INTO timesheet (notes, attachment, starttime, endtime, jobid, userid) VALUES (?,?,?,?,?,?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.dataTableDb, queryString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (notes as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (attachment as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (starttime as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (endtime as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 5, Int32(jobid))
            sqlite3_bind_int(insertStatement, 6, Int32(userid))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    
    @IBAction func switchBtn(_ sender: Any) {
        self.notesString = noteString.text!
        workTimer?.invalidate()
        
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "jobSwitchVC") as! JobSwitchViewController
        myVC.selectedJobId = self.selectedJobId
        myVC.notes = self.notesString
        myVC.attachmentImagearray = self.attachmentImagearray as? Array<UIImage>
        
        //let navController = UINavigationController(rootViewController: myVC)
        //self.navigationController?.present(navController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(myVC, animated: true)
        
    }
    
    // UICollectionView function
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentImagearray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentImage", for: indexPath) as! AttachmentImageCollectionViewCell
        cell.attachmentImageViewCell.image = attachmentImagearray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // add attachment event
            // take photo or select photo from gallery
            let picker = UIImagePickerController()
            picker.delegate = self
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
                action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
                action in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print(indexPath.item)
    }
    
    
    // to take a photo or select image from library
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //use image here!
        attachmentImagearray.append(image)
        let insertedIndexPath = IndexPath(item: attachmentImagearray.count - 1, section: 0)
        attachmentCollectionView.insertItems(at: [insertedIndexPath])

        dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // image upload to server
    func myTimecardUploadRequest(userid: Int, jobid: Int, notes: String, starttime: String, endtime: String, attachmentImagearray: Array<UIImage>)
    {
        
        guard let myUrl = NSURL(string: "http://192.168.124.18/api/upload/uploadtimesheet") else { return }
        
        let request = NSMutableURLRequest(url:myUrl as URL);
        request.httpMethod = "POST";
        
        let param = [
            "userid"    : userid,
            "jobid"     : jobid,
            "notes"     : notes,
            "starttime" : starttime,
            "endtime"   : endtime
            ] as [String : Any]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        //let imageData = UIImageJPEGRepresentation(UIImage(named: "attachments.png")!, 1)
//        let base64String = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        
        //if(imageData==nil)  { return }
        
        request.httpBody = createBodyWithParameters(parameters: param, imageArray: attachmentImagearray, boundary: boundary) as Data
        
        print(request.httpBody as Any)
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            if let response = response {
                print(response)
                print(data as Any)
            }
            guard let data = data else { return }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                let success = jsonResult!["success"] as? Int
                print(jsonResult as Any)
                if success == 1 {
                    print("OK")
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: Any]?, imageArray: Array<UIImage>, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        
        if imageArray.count > 1 {
            var index = 0
            for image in imageArray {
                if index > 0 {
                    let filename = "attachment" + String(index)
                    let mimetype = "image/jpeg"
                    let filePathKey = "file" + String(index)
                    let imageDataKey = UIImageJPEGRepresentation(image, 1)! as NSData
                    
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
                    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                    body.append(imageDataKey as Data)
                    body.appendString(string: "\r\n")
                }
                
                index += 1
            }
        }
        
//        body.appendString(string: "--\(boundary)\r\n")
//        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
//        body.append(imageDataKey as Data)
//        body.appendString(string: "\r\n")
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    // job picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jobList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return jobList[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.jobInputString.text = self.jobList[row]
        self.selectedJobId = self.jobIdList[row]
        self.jobSelectDropdown.isHidden = true
    }
    
    // text editing
    func textFieldDidBeginEditing( _ textfield: UITextField) {
        if textfield == self.jobInputString {
            self.jobSelectDropdown.isHidden = false
            textfield.endEditing(true)
        }
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


extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String
{
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
    }
}

