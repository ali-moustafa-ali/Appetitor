//
//  ChooseCountryCodeVC.swift
//  Wingo_Live
//
//  Created by karim metawea on 8/23/19.
//  Copyright © 2019 Eslam Muhammed. All rights reserved.
//

import UIKit

class ChooseCountryCodeVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var countries = [Country]()
    let letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let arabicLetters = "ا ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ق ك ل م ن ه و ي"
    var arabicLettersArray:[String] = []
    var countriesDictionary = [String:[Country]]()
    var didSelectCountry:((Country)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = sel
        arabicLettersArray = arabicLetters.components(separatedBy: " ")
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.tableFooterView =  UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        
            if let countries =  readJsonFile().loadJson(filename: "countries"){
               
                self.countries = countries
                self.createCountriesDict()
                self.tableView.reloadData()
            }
            
            //            self.hud.dismiss(afterDelay: 1)
            
        

        // Do any additional setup after loading the view.
    }
    func createCountriesDict(){
        if Helper.isEnglish(){
            for letter in letters {
                countriesDictionary[letter] = countries.filter({
                    countryName(countryCode: $0.code)?.first == letter.first
                })
            }
        }else{
            for letter in arabicLettersArray {
                countriesDictionary[letter] = countries.filter({
                    countryName(countryCode: $0.code)?.first == letter.first
                })
            }
        }
        
    }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: Helper.getAppLanguage())
        return current.localizedString(forRegionCode: countryCode)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension ChooseCountryCodeVC:UITableViewDelegate,UITableViewDataSource{
   
        func numberOfSections(in tableView: UITableView) -> Int {
            return Helper.isEnglish() ? letters.count:arabicLettersArray.count
        }
        
        //    data source methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let countriesForSection = countriesDictionary[Helper.isEnglish() ? letters[section]:arabicLettersArray[section]] else {return 0}
            return countriesForSection.count
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return Helper.isEnglish() ? letters[section]:arabicLettersArray[section]
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as! CountryCodeCell
            guard let countriesForSection = countriesDictionary[Helper.isEnglish() ? letters[indexPath.section]:arabicLettersArray[indexPath.section]] else {return UITableViewCell()}
            let country = countriesForSection[indexPath.row]
            cell.configureCell(country:country)
            return cell
        }
        
    
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let countries = countriesDictionary[Helper.isEnglish() ? letters[indexPath.section]:arabicLettersArray[indexPath.section]] else {return}
            let country = countries[indexPath.row]
            didSelectCountry?(country)
            self.dismiss(animated: true, completion: nil)
        }
        
        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return  Helper.isEnglish() ? letters:arabicLettersArray
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            if section == 2 || section == 3 || section == 5 || section ==  6 || section == 7 || section == 13 || section == 17 || section == 21 || section == 22 || section == 23 || section == 25{
//                return 0
//            }
            return 30
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
            
    }
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            let view = view as! UITableViewHeaderFooterView
            view.contentView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
            view.textLabel?.textColor = .gray
        }
}
