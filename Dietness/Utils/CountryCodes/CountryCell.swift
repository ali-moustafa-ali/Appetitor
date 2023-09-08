//
//  CountryCodeCell.swift
//  Dubailad
//
//  Created by karim metawea on 9/8/20.
//  Copyright © 2020 Rami Suliman. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(country:Country){
        countryName.text = countryName(countryCode: country.code)
//        countryImage.kf.indicatorType = .activity
//        countryImage.kf.setImage(with: URL(string: "https://www.countryflags.io/\(country.code)/shiny/64.png")!, placeholder: UIImage(named: "PlaceHolder"), options:  [.transition(.fade(0.1))])
        countryImage.image = getFlag(from: country.code).emojiToImage()
        
                     }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: Helper.getAppLanguage())
        return current.localizedString(forRegionCode: countryCode)
    }
    
     func getFlag(from countryCode: String) -> String {

        return countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

//https://www.countryflags.io/SA/shiny/64.png
extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
