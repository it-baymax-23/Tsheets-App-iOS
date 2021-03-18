//
//  AddNotesViewController.swift
//  wowsheet
//
//  Created by AAA on 7/18/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class AddNotesViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var addNotesTextView: UITextView!
    
    public var notes: String! = "Add Notes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if notes == "Add Notes" {
            addNotesTextView.text = "Add Notes"
            addNotesTextView.textColor = UIColor.lightGray
        } else {
            addNotesTextView.text = notes
            addNotesTextView.textColor = UIColor.black
        }
        
        addNotesTextView.layer.borderWidth = 1
        addNotesTextView.layer.borderColor = UIColor.lightGray.cgColor
        addNotesTextView.layer.cornerRadius = 5
        
        addNotesTextView.delegate = self
        
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        self.navigationItem.rightBarButtonItem = saveBtn

        // Do any additional setup after loading the view.
    }
    
    @objc func save() {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "addScheduleVC") as! AddScheduleViewController
        myVC.notes = self.addNotesTextView.text
        self.navigationController?.pushViewController(myVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

}
