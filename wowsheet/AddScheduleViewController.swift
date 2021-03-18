//
//  AddScheduleViewController.swift
//  wowsheet
//
//  Created by AAA on 7/17/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class AddScheduleViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var allDaySwitch: UISwitch!
    
    @IBOutlet weak var addJobView: UIView!
    @IBOutlet weak var addJobLabel: UILabel!
    
    @IBOutlet weak var assignedView: UIView!
    @IBOutlet weak var assignedLabel: UILabel!
    
    @IBOutlet weak var addLocationView: UIView!
    @IBOutlet weak var addLocationLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorImageView: UIImageView!
    
    @IBOutlet weak var addNotesView: UIView!
    @IBOutlet weak var addNotesLabel: UILabel!
    
    @IBOutlet weak var saveDraftBtn: UIButton!
    @IBOutlet weak var publishBtn: UIButton!
    
    public var scheduleTitle: String!
    public var scheduleDate: String!
    public var scheduleStartTime: String!
    public var scheduleEndTime: String!
    public var scheduleAllDay: Bool!
    
    public var jobId: Int!
    public var jobName: String! = "Add Job"
    public var notes: String! = "Add Notes"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInit()
        labelClicked()         // change date, start time and end time
        viewClicked()          // add job view click
        addNotesClicked()      // add notes view click
        
        addJobLabel.text = jobName
        addNotesLabel.text = notes
        
    }
    
    func labelClicked(){
        dateLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelClicked))
        dateLabel.addGestureRecognizer(gesture)
        
        startTimeLabel.isUserInteractionEnabled = true
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(startTimeLabelClicked))
        startTimeLabel.addGestureRecognizer(gesture1)
        
        endTimeLabel.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(endTimeLabelClicked))
        endTimeLabel.addGestureRecognizer(gesture2)
    }
    
    @objc func dateLabelClicked(){
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "E MMM dd, yyyy"
                self.dateLabel.text = formatter.string(from: dt)
                self.dateLabel.sizeToFit()
            }
        }
    }
    
    @objc func startTimeLabelClicked(){
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (time) -> Void in
            if let dt = time {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                self.startTimeLabel.text = formatter.string(from: dt)
                self.startTimeLabel.sizeToFit()
            }
        }
    }
    
    @objc func endTimeLabelClicked(){
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (time) -> Void in
            if let dt = time {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                self.endTimeLabel.text = formatter.string(from: dt)
                self.endTimeLabel.sizeToFit()
            }
        }
    }
    
    // Add job view click event
    func viewClicked(){
        addJobView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addJobViewClicked))
        addJobView.addGestureRecognizer(gesture)
    }
    
    @objc func addJobViewClicked() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "selectJobVC") as? SelectJobViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // Add notes view click event
    func addNotesClicked(){
        addNotesView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addNotesViewClicked))
        addNotesView.addGestureRecognizer(gesture)
    }
    
    @objc func addNotesViewClicked() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addNotesViewController") as? AddNotesViewController
        vc?.notes = addNotesLabel.text
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func viewInit() {
        // set title and draw cancel button
        self.title = "Add Shift"
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.viewClose))
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        // initiate view
        dateTimeView.layer.borderWidth = 0.5
        dateTimeView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        addJobView.layer.borderWidth = 0.5
        addJobView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        assignedView.layer.borderWidth = 0.5
        assignedView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        addLocationView.layer.borderWidth = 0.5
        addLocationView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        colorView.layer.borderWidth = 0.5
        colorView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        addNotesView.layer.borderWidth = 0.5
        addNotesView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        saveDraftBtn.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width / 2 - 15 , height: 40)
        saveDraftBtn.layer.cornerRadius = 2
        publishBtn.frame = CGRect(x: UIScreen.main.bounds.width / 2 + 5, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width / 2 - 15 , height: 40)
        publishBtn.layer.cornerRadius = 2
        
        addJobLabel.frame = CGRect(x: 50, y: 2, width: UIScreen.main.bounds.width - 55, height: 60)
        addJobLabel.numberOfLines = 2
        
        assignedLabel.frame = CGRect(x: 50, y: 2, width: UIScreen.main.bounds.width - 55, height: 60)
        assignedLabel.numberOfLines = 2
        
        addLocationLabel.frame = CGRect(x: 50, y: 2, width: UIScreen.main.bounds.width - 55, height: 60)
        addLocationLabel.numberOfLines = 2
        
        colorLabel.frame = CGRect(x: 50, y: 2, width: UIScreen.main.bounds.width - 55, height: 60)
        
        addNotesLabel.frame = CGRect(x: 50, y: 2, width: UIScreen.main.bounds.width - 55, height: 80)
        addNotesLabel.numberOfLines = 3
        
        dateLabel.text = toString(date: Date())
        dateLabel.sizeToFit()
        
        allDaySwitch.isOn = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func viewClose(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allDaySwitchClicked(_ sender: Any) {
        if allDaySwitch.isOn == true {
            startTimeLabel.isHidden = true
            endTimeLabel.isHidden = true
        } else {
            startTimeLabel.isHidden = false
            endTimeLabel.isHidden = false
        }
    }
    @IBAction func publishBtnClick(_ sender: Any) {
    }
    @IBAction func saveDraftBtnClick(_ sender: Any) {
    }
    
    func toString( date: Date ) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM dd, yyyy"
        return formatter.string(from: date)
    }
}
