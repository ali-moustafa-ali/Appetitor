//
//  PlanCell.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/14/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {

    @IBOutlet weak var planDesc: UILabel!
    @IBOutlet weak var planWeight: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            planDesc.superview?.superview?.backgroundColor = UIColor.PrimaryColor
        }
        else {
            planDesc.superview?.superview?.backgroundColor = UIColor.white
        }
        // Configure the view for the selected state
    }

}
