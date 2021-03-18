//
//  ScheduleTableViewCell.swift
//  wowsheet
//
//  Created by AAA on 7/17/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    @IBOutlet weak var startTimeEndTimeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scheduleColorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
