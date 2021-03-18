//
//  ViewController.swift
//  wowsheet
//
//  Created by AAA on 7/5/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstbgimgview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

