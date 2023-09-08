//
//  MainCell.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/13/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
