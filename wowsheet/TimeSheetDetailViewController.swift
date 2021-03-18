//
//  TimeSheetDetailViewController.swift
//  wowsheet
//
//  Created by AAA on 7/16/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class TimeSheetDetailViewController: UIViewController {

    @IBOutlet weak var startEndTimeViewOutlet: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var jobViewOutlet: UIView!
    @IBOutlet weak var jobNameLabel: UILabel!
    
    @IBOutlet weak var noteViewOutlet: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var locationViewOutlet: UIView!
    
    @IBOutlet weak var attachmentOutlet: UICollectionView!
    
    
    public var date: String!
    public var startTime: String!
    public var endTime: String!
    public var totalTime: String!
    public var jobName: String!
    public var notes: String!
    public var location: String!
    public var attachment: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewInit()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func viewInit(){
        startEndTimeViewOutlet.layer.borderWidth = 1
        startEndTimeViewOutlet.layer.cornerRadius = 2
        startEndTimeViewOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        jobViewOutlet.layer.borderWidth = 1
        jobViewOutlet.layer.cornerRadius = 2
        jobViewOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        noteViewOutlet.layer.borderWidth = 1
        noteViewOutlet.layer.cornerRadius = 2
        noteViewOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        locationViewOutlet.layer.borderWidth = 1
        locationViewOutlet.layer.cornerRadius = 2
        locationViewOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        
        attachmentOutlet.layer.borderWidth = 1
        attachmentOutlet.layer.cornerRadius = 2
        attachmentOutlet.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
        

        startTimeLabel.text = startTime
        endTimeLabel.text = endTime
        totalTimeLabel.text = totalTime
        jobNameLabel.text = jobName
        noteLabel.text = notes
        
        self.title = date
        
        jobNameLabel.numberOfLines = 2;
        noteLabel.numberOfLines = 3;
        jobNameLabel.numberOfLines = 3;
        
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
