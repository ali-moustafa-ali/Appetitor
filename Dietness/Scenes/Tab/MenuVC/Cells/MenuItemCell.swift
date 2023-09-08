//
//  MenuItemCell.swift
//  Dietness
//
//  Created by karim metawea on 2/18/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import Kingfisher

class MenuItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    func configureCell(product:Product,url:String){
        self.selectedView.isHidden = !(product.isSelected ?? false)
        let imgURL = "\(url)/\(product.image ?? "")"
        if let url = URL(string:imgURL) {
            itemImage.kf.indicatorType = .activity
            itemImage.kf.setImage(with: url, placeholder: UIImage(named: "default"), options:  [.transition(.fade(0.1))])
        }
        self.itemName.text = product.title
        self.itemDescription.text = product.desc
    }
}
