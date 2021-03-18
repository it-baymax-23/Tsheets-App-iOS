//
//  TimeCardTableViewCell.swift
//  wowsheet
//
//  Created by AAA on 7/14/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class TimeCardTableViewCell: UITableViewCell {

    @IBOutlet weak var jobNameLabelOutlet: UILabel!
    @IBOutlet weak var totalWorkTimeLabelOutlet: UILabel!
    @IBOutlet weak var startAndEndTimeLabelOutlet: UILabel!
    @IBOutlet weak var startAndEndTimeLabelOutlet1: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
