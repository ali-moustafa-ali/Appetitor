//
//  MenuHeader.swift
//  Dietness
//
//  Created by karim metawea on 2/20/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit


protocol CustomHeaderViewDelegate: class {
    func freezeDay(isFreezed:Bool)
}

class MenuHeader: UICollectionReusableView {
        
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var freezeButton: UIButton!
    
    var section: Int?
    weak var delegate: CustomHeaderViewDelegate?
    var isFreezed:Bool = false

    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.section = nil
//        freezeButton.isHidden = true
    }
    
    
    @IBAction func freeze(_ sender: Any) {
        guard let section = self.section else {
            return
        }
        self.delegate?.freezeDay(isFreezed: isFreezed)
    }
}
