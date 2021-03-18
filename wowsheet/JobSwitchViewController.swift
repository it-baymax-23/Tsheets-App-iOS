//
//  JobSwitchViewController.swift
//  wowsheet
//
//  Created by AAA on 7/13/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class JobSwitchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var switchTimeViewOutlet: UIView!
    @IBOutlet weak var switchTime: UILabel!
    @IBOutlet weak var selectJobTextfield: UITextField!
    @IBOutlet weak var selectJobDropdown: UIPickerView!
    @IBOutlet weak var notesTextfield: UITextField!
    
    public var switchTimeUpdateTimer: Timer?
    
    public var selectedJobId: Int = 0
    public var notes: String = ""
    public var attachmentImagearray : Array<UIImage>?
    
    public var newSelectedJobId: Int = 0
    public var newNotes: String = ""
    
    var jobList = ["Job 1", "Job 2", "Job 3", "Job 4", "Job 5", "Job 6", "Job 7", "Job 8", "Job 9"]
    var jobIdList = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    let myPreferences = UserDefaults.standard
    let startTimeKey = "startTime"
    let loginStatusKey = "loginStatus"
    let loginUserIdKey = "loginUserId"
    let loginUserNameKey = "loginUserName"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        print(selectedJobId)
        print(notes)
        print(attachmentImagearray?.count as Any)
        
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.viewClose))
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveTimeCard))
        self.navigationItem.rightBarButtonItem = saveBtn
        
        switchTime.text = getCurrentTimeWithFormat(Date())
        switchTimeUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(switchTimeUpdate), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        switchTimeViewOutlet.layer.borderWidth = 1
        switchTimeViewOutlet.layer.cornerRadius = 2
        switchTimeViewOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        selectJobTextfield.layer.borderWidth = 1
        selectJobTextfield.layer.cornerRadius = 2
        selectJobTextfield.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        selectJobDropdown.layer.borderWidth = 1
        selectJobDropdown.layer.cornerRadius = 2
        selectJobDropdown.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        notesTextfield.layer.borderWidth = 1
        notesTextfield.layer.cornerRadius = 2
        notesTextfield.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func viewClose() {
        switchTimeUpdateTimer?.invalidate()
        //self.dismiss(animated: true, completion: nil)
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "timeCardVC") as! AdminTimeCardViewController
        myVC.selectedJobId = self.selectedJobId
        myVC.notesString = self.notes
        myVC.totalWorkTime = 0
        myVC.clockInCheck = true
        myVC.switchCheck = 2
        myVC.attachmentImagearray = self.attachmentImagearray!
        
//        let navController = UINavigationController(rootViewController: myVC)
//        self.navigationController?.present(navController, animated: true, completion: nil)
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    @objc func saveTimeCard() {
//        self.dismiss(animated: true, completion: nil)
        
//        if AdminTimeCardViewController().totalWorkTime > 60 {
//            AdminTimeCardViewController().totalWorkTime = 0
//            AdminTimeCardViewController().saveMyTimeCard()
//        }
        
        switchTimeUpdateTimer?.invalidate()
        
        self.saveMyTimeCard()
        
        // update start time
        myPreferences.set(Date(), forKey: startTimeKey)
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "timeCardVC") as! AdminTimeCardViewController
        myVC.selectedJobId = self.newSelectedJobId
        newNotes = notesTextfield.text!
        myVC.notesString = self.newNotes
        myVC.totalWorkTime = 0
        myVC.clockInCheck = true
        myVC.switchCheck = 1
        
        //let navController = UINavigationController(rootViewController: myVC)
        //self.navigationController?.present(navController, animated: true, completion: nil)
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    @objc func switchTimeUpdate() {
        switchTime.text = getCurrentTimeWithFormat(Date())
    }
    
    func saveMyTimeCard(){
        
        let userid = myPreferences.integer(forKey: self.loginUserIdKey)
        let jobid = self.selectedJobId
        let notes = self.notes
        let attachmentImagearray = self.attachmentImagearray
        
        // starttime
        let startTimeFromPreference: Date = myPreferences.object(forKey: startTimeKey) as! Date
        let starttime = startTimeFromPreference.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        // endtime
        let endtime = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        print(starttime)
        print(endtime)
        print(notes)
        print(jobid)
        print(userid)
        
        myTimecardUploadRequest(userid: userid, jobid: jobid, notes: notes, starttime: starttime, endtime: endtime, attachmentImagearray: attachmentImagearray!)
        
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
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    //-------------------------------------------------------------------------------------
    
    
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
        self.selectJobTextfield.text = self.jobList[row]
        self.newSelectedJobId = self.jobIdList[row]
        self.selectJobDropdown.isHidden = true
    }
    
    // text editing
    func textFieldDidBeginEditing( _ textfield: UITextField) {
        if textfield == self.selectJobTextfield {
            self.selectJobDropdown.isHidden = false
            textfield.endEditing(true)
        }
    }
    

}
