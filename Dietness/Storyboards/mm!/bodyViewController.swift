//
//  bodyViewController.swift
//  Ali
//
//  Created by Ali Moustafa on 08/09/2023.
//

import UIKit

class bodyViewController: UIViewController {
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var dateOfBirth: UIView!
    @IBOutlet var btnRadioAll: [UIButton]!
    
    @IBOutlet weak var hiehtOfFirstTable: NSLayoutConstraint!
    @IBOutlet weak var hiehtOfFirstTable2: NSLayoutConstraint!
    
    var arrDisLiked = [DisLikedElement]()
    var arrSelectedCountry = [DisLikedElement]()
    
    var arrDisLiked2 = [DisLikedElement2]()
    var arrSelectedCountry2 = [DisLikedElement2]()
    
    @IBOutlet weak var tblCheckList: UITableView!{
        didSet{
            let nib = UINib(nibName: "cellOfDissLiked", bundle: nil)
            tblCheckList.register(nib, forCellReuseIdentifier: "cellOfDissLiked")
            tblCheckList.dataSource = self
            tblCheckList.delegate = self
        }
    }

    @IBOutlet weak var tblCheckList2: UITableView!{
        didSet{
            let nib = UINib(nibName: "cellOfDissLiked", bundle: nil)
            tblCheckList2.register(nib, forCellReuseIdentifier: "cellOfDissLiked")
            tblCheckList2.dataSource = self
            tblCheckList2.delegate = self
        }
    }


    @IBOutlet weak var confirmButtonOL: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRadioAllAction(btnRadioAll[0])
        ReadJSONFile()

        // Usage in viewDidLoad or wherever needed
        styleView(weightView, cornerRadius: 10.0)
        styleView(heightView, cornerRadius: 10.0)
        styleView(dateOfBirth, cornerRadius: 10.0)
        
        confirmButtonOL.layer.cornerRadius = 5 // Adjust the value as needed
        confirmButtonOL.clipsToBounds = true // This ensures the corner radius is applied

    }


    func styleView(_ view: UIView, cornerRadius: CGFloat) {
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = cornerRadius
    }

    @IBAction func btnRadioAllAction(_ sender: UIButton) {
        
        print("Tag of the clicked button>>>", sender.tag)
        
        for btn in btnRadioAll{
            if sender.tag == btn.tag{ //Clicked button tag
                btn.setImage(UIImage(named: "ic_On"), for: .normal)
            }else{
                btn.setImage(UIImage(named: "ic_Off"), for: .normal)
            }
        }
        
    }

    @IBAction func confirmClicked(_ sender: UIButton) {
    }
    
}






extension bodyViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblCheckList {
        return 1
        }else{
        return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblCheckList {
            return arrDisLiked.count
        }else{
            return arrDisLiked2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblCheckList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfDissLiked") as? cellOfDissLiked
            let countryModel =  arrDisLiked[indexPath.row]
            cell?.lblCountry.text = countryModel.name
            cell?.btnCheckUncheck.tag = indexPath.row
            cell?.btnCheckUncheck.setImage(UIImage.init(named: "uncheck"), for: .normal)
            cell?.btnCheckUncheck.setImage(UIImage.init(named: "check"), for: .selected)
            cell?.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClick(_sender:)), for: .touchUpInside)
            let CountrySelect = arrSelectedCountry.first{$0.name == "\(countryModel.name)"}
            if CountrySelect != nil{
                cell?.btnCheckUncheck.isSelected = true
            }else{
                cell?.btnCheckUncheck.isSelected = false
            }
            return cell!

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfDissLiked") as? cellOfDissLiked
            let countryModel =  arrDisLiked2[indexPath.row]
            cell?.lblCountry.text = countryModel.name
            cell?.btnCheckUncheck.tag = indexPath.row
            cell?.btnCheckUncheck.setImage(UIImage.init(named: "uncheck"), for: .normal)
            cell?.btnCheckUncheck.setImage(UIImage.init(named: "check"), for: .selected)
            cell?.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClick(_sender:)), for: .touchUpInside)
            let CountrySelect = arrSelectedCountry2.first{$0.name == "\(countryModel.name)"}
            if CountrySelect != nil{
                cell?.btnCheckUncheck.isSelected = true
            }else{
                cell?.btnCheckUncheck.isSelected = false
            }
            return cell!

        }
    

    }
    
    
    
    
    @IBAction func btnCheckUncheckClick(_sender:UIButton){
        _sender.isSelected = !_sender.isSelected
        let selectedCountry = arrDisLiked[_sender.tag]
        var isExist = false
        for i in 0..<arrSelectedCountry.count{
            let countryModel = arrSelectedCountry[i]
            if countryModel.name == selectedCountry.name{
                isExist = true
                arrSelectedCountry.remove(at: i)
                return
            }
        }
        
        if !isExist{
            arrSelectedCountry.append(selectedCountry)
        }
        tblCheckList.reloadData()
        print(arrSelectedCountry.description)
        calculateTableViewHeight() // Adjust the table view's height after loading data

        
    }
    
    @IBAction func btnCheckUncheckClick2(_sender:UIButton){
        _sender.isSelected = !_sender.isSelected
        let selectedCountry = arrDisLiked2[_sender.tag]
        var isExist = false
        for i in 0..<arrSelectedCountry2.count{
            let countryModel = arrSelectedCountry2[i]
            if countryModel.name == selectedCountry.name{
                isExist = true
                arrSelectedCountry2.remove(at: i)
                return
            }
        }
        
        if !isExist{
            arrSelectedCountry2.append(selectedCountry)
        }
        tblCheckList2.reloadData()
        print(arrSelectedCountry2.description)
        calculateTableViewHeight2() // Adjust the table view's height after loading data

    }
    
    
    
    func ReadJSONFile()
    {
        let fileName = "Country"
        let fileType = "json"
        
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType){
            do{
                let data = try Data(contentsOf: URL(filePath: path),options: .mappedIfSafe)
                arrDisLiked = try! JSONDecoder().decode(DisLiked.self, from: data)
                arrDisLiked2 = try! JSONDecoder().decode(DisLiked2.self, from: data)
                self.tblCheckList.reloadData()
                self.tblCheckList2.reloadData()
                print(arrDisLiked.count, "Ali")
                calculateTableViewHeight() // Adjust the table view's height after loading data
                calculateTableViewHeight2() // Adjust the table view's height after loading data

            }catch{
              print("Json file not found")
            }
            
            
        }else
        
        
        {
            
        }
        
    }
    func calculateTableViewHeight() {
        tblCheckList.reloadData() // Reload the table view data
        tblCheckList.layoutIfNeeded() // Ensure layout calculations are up to date
        let totalHeight = tblCheckList.contentSize.height // Get the total content height
        hiehtOfFirstTable.constant = totalHeight // Set the height constraint's constant value
    }
    func calculateTableViewHeight2() {
        tblCheckList2.reloadData() // Reload the table view data
        tblCheckList2.layoutIfNeeded() // Ensure layout calculations are up to date
        let totalHeight = tblCheckList2.contentSize.height // Get the total content height
        hiehtOfFirstTable2.constant = totalHeight // Set the height constraint's constant value
    }
   
}

