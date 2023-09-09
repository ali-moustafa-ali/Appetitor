//
//  cellOfDissLiked.swift
//  Ali
//
//  Created by Ali Moustafa on 08/09/2023.
//

import UIKit

class cellOfDissLiked: UITableViewCell {

    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var btnCheckUncheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
}
