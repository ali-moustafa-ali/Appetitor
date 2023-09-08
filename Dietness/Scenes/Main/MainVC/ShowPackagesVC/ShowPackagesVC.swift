//
//  ShowPackagesVC.swift
//  Dietness
//
//  Created by Ahmad medo on 08/09/2023.
//  Copyright © 2023 Dietness. All rights reserved.
//

import UIKit

class ShowPackagesVC: UIViewController {
        
    @IBOutlet weak var packagesTableView: UITableView!

    
    var packages : [Package] = []
    var imageURL = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getPackages()
    }
    
    func getPackages() {
        self.view.makeToastActivity(.center)
        Connect.default.request(MainConnector.getPackages).decoded(toType: PackagesResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
    
            case .success(let data):
                print("packages success")
                self.packages = data.result?.packages ?? []
                print(self.packages)
                self.imageURL = data.result?.image_url ?? ""

                DispatchQueue.main.async {
                    self.packagesTableView.reloadData()

                }
                
            case .failure(let error):
                print("packages failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
}


//MARK: Table for packages

extension ShowPackagesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! NewPackagesCell

        let imgURL = "\(imageURL)/\(packages[indexPath.row].image ?? "")"

        if let url = URL(string: imgURL) {
            cell.packageImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "default"))
        }

        cell.moreBtnOutlet.onTap { [weak self] in

            let vc = self?.storyboard?.instantiateViewController(identifier: "PackagePopUpVC") as! PackagePopUpVC

            vc.package = self?.packages[indexPath.row]
            vc.imageURL = imgURL

            vc.didTapSubscribe = {[weak self]  planId in

                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC


                vc.planId = planId


                self?.navigationController?.pushViewController(vc, animated: true)
            }

            self?.present(vc, animated: true, completion: nil)
        }

        return cell
    }


}


class NewPackagesCell: UITableViewCell {

    
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
