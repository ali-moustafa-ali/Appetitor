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
    
    private var SportsTargets: [SportsTarget] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = "What is your sporting goal?".localized
        

        
        getSportsTargets()
        
    }
    
    // MARK: Api
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

// MARK: Cell
class SportsTargetCell: UITableViewCell {

    @IBOutlet weak var bigTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

// MARK: Para models
class FullSignUpInformation{

    // 1
    var signUpInfo: SignUpInfo?

    // 2
    var userInformation: UserInformation?

    // 3
    var sportsTargetId: Int?
    
    
    func getParams()-> [String: Any]?{
        
        // 1
        var signUpInfoParams = signUpInfo?.getParams()
        
        
        signUpInfoParams?["sport_target_id"] = String(sportsTargetId ?? -1)

        
        let userInformationDict = userInformation?.getParams()
        
        if var signUpInfoParams = signUpInfoParams,
           let userInformationDict = userInformationDict{
            
           signUpInfoParams.merge(userInformationDict) { (_, new) in new }
            
            return signUpInfoParams

            
        }else{
            return nil
        }

    }
}


class UserInformation{
    
    var weight: String?
    var height: String?
    var birth_date: String?
    var gender: String?
    var food_system: String?
    
    var allergen_id: [String]?
    var excluded_classifications: [String]?
    
    
    init(weight: String?,
         height: String?,
         birth_date: String?,
         gender: String?,
         food_system: String?,
         allergen_id: [String]?,
         excluded_classifications: [String]?

    ){
        self.weight = weight
        self.height = height
        self.birth_date = birth_date
        self.gender = gender
        self.food_system = food_system
        self.allergen_id  = allergen_id
        self.excluded_classifications  = excluded_classifications

    }
    
    
    func getParams()-> [String: Any]{
                
        var para = [String: Any]()
        
        //
        if let weight = weight{ para["weight"] = weight }
        
        if let height = height{ para["height"] = height }

        if let birth_date = birth_date{ para["birth_date"] = birth_date }

        if let gender = gender{ para["gender"] = gender }

        if let food_system = food_system{ para["food_system"] = food_system }

        if let allergen_id = allergen_id{ para["allergen_id"] = allergen_id }

        if let excluded_classifications = excluded_classifications{ para["excluded_classifications"] = excluded_classifications }


        
        return para
    }

}

//map.put("name", AppSession.signupRequestBuilder.getName());
//map.put("mobile", AppSession.signupRequestBuilder.getMobile());
//map.put("email", AppSession.signupRequestBuilder.getEmail());
//map.put("password", AppSession.signupRequestBuilder.getPassword());
//map.put("verify_password", AppSession.signupRequestBuilder.getVerifyPassword());
//map.put("code", AppSession.signupRequestBuilder.getCode());

//map.put("sport_target_id", AppSession.signupRequestBuilder.getSport_target_id());

//map.put("planId", String.valueOf(AppSession.signupRequestBuilder.getPlanId()));


//map.put("weight", String.valueOf(AppSession.signupRequestBuilder.getWeight()));
//map.put("height", String.valueOf(AppSession.signupRequestBuilder.getHeight()));
//map.put("birth_date", AppSession.signupRequestBuilder.getBirthDate());
//map.put("gender", String.valueOf(AppSession.signupRequestBuilder.getGender()));
//map.put("food_system", String.valueOf(AppSession.signupRequestBuilder.getFood_system()));
//map.put("allergen_id", AppSession.signupRequestBuilder.getExcludedAllergens());
//map.put("excluded_classifications", AppSession.signupRequestBuilder.getExcludedClassifications());
//
