//
//  SportsTargetVC.swift
//  Dietness
//
//  Created by Ahmad medo on 08/09/2023.
//  Copyright © 2023 Dietness. All rights reserved.
//

import UIKit

class SportsTargetVC: UIViewController {

    @IBOutlet weak var sportsTargetTable: UITableView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var choseSportsTargetCompletion: ((SportsTargetVC, Int)->())?
    
    var SportsTargets: [SportsTarget] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = "What is your sporting goal?".localized
        
        
        getSportsTargets()
        
    }
    
    func getSportsTargets() {
        self.view.makeToastActivity(.center)
        Connect.default.request(MainConnector.sportTargets).decoded(toType: SportsTargetModel.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
    
            case .success(let data):
                print("SportsTargets success")
                self.SportsTargets = data.result ?? []
                print(self.SportsTargets)

                
                DispatchQueue.main.async {
                    self.sportsTargetTable.reloadData()

                }
                
            case .failure(let error):
                print("packages failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }


}
//MARK: Table for packages

extension SportsTargetVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SportsTargets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportsTargetCell", for: indexPath) as! SportsTargetCell
        
        let title = Helper.language == "ar" ? SportsTargets[indexPath.row].nameAr : SportsTargets[indexPath.row].nameEn
        
        cell.titleLbl.text = title
        cell.bigTitleLbl.text = title

        
//        let imgURL = "\(imageURL)/\(SportsTargets[indexPath.row].image ?? "")"
//
//        if let url = URL(string: imgURL) {
//            cell.packageImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "default"))
//        }
        
        
        cell.moreBtnOutlet.onTap { [weak self] in

            guard let self = self, let targetId = SportsTargets[indexPath.row].id else{return}
            
            self.choseSportsTargetCompletion!(self, targetId)

        }

        return cell
    }
}

class SportsTargetCell: UITableViewCell {

    @IBOutlet weak var bigTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }



}
