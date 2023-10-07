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
    @IBOutlet weak var contentView2: UIView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    
    @IBOutlet weak var titleLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView2.layer.borderWidth = 3
        contentView2.layer.borderColor = UIColor(hex: "01ADBB").cgColor
    }



}
