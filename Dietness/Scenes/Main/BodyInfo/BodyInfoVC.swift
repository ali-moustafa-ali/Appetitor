//
//  bodyViewController.swift
//  Ali
//
//  Created by Ali Moustafa on 08/09/2023.
//

import UIKit

class BodyInfoVC: UIViewController {
    
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var dateOfBirth: UIView!
    
    @IBOutlet var btnRadioAll: [UIButton]!
    
    @IBOutlet weak var hiehtOfFirstTable: NSLayoutConstraint!
    @IBOutlet weak var hiehtOfFirstTable2: NSLayoutConstraint!
    
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
    
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var confirmButtonOL: UIButton!
    
    
    var arrDisLiked = [DisLikedElement]()
    var arrSelectedCountry = [DisLikedElement]()
    
    var arrDisLiked2 = [DisLikedElement2]()
    var arrSelectedCountry2 = [DisLikedElement2]()
    
    var userInformation: UserInformation?
    
    var finishedBodyInfoCompletion: ((BodyInfoVC, UserInformation)->Void)?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateField.delegate = self
        
        btnRadioAllAction(btnRadioAll[0])
        
        // Usage in viewDidLoad or wherever needed
        styleView(weightView, cornerRadius: 10.0)
        styleView(heightView, cornerRadius: 10.0)
        styleView(dateOfBirth, cornerRadius: 10.0)
        
        confirmButtonOL.layer.cornerRadius = 5 // Adjust the value as needed
        confirmButtonOL.clipsToBounds = true // This ensures the corner radius is applied
        
    }
    
    
    private func styleView(_ view: UIView, cornerRadius: CGFloat) {
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = cornerRadius
    }
    
    // MARK: Actions
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
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        guard let userInformation = getUserInformation() else{
            
            view.makeToast("Please complete all required data")
            
            return
        }
        
        finishedBodyInfoCompletion!(self, userInformation)
        
        //        signUpInformation?.signUpInfo = signUpInfo
        
        
    }
    
    private func getUserInformation()->UserInformation?{
        
        if let height = heightField.text,
           let weight = weightField.text,
           let date = dateField.text
        //           let phone = phoneTextField.text,
        //           let password = passwordTextField.text
        {
            
            return UserInformation(weight: weight, height: height,
                                   birth_date: date,
                                   gender: "1", food_system: "1",
                                   allergen_id: ["4","5"], excluded_classifications: ["1","2"])
        }
        
        return nil
    }
    
    
}


// MARK: Table
extension BodyInfoVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tblCheckList ? arrDisLiked.count : arrDisLiked2.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblCheckList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfDissLiked") as! cellOfDissLiked
            
            let countryModel =  arrDisLiked[indexPath.row]
            
            cell.lblCountry.text = countryModel.name
            cell.btnCheckUncheck.tag = indexPath.row
            cell.btnCheckUncheck.setImage(UIImage.init(named: "uncheck"), for: .normal)
            cell.btnCheckUncheck.setImage(UIImage.init(named: "check"), for: .selected)
            cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClick(_sender:)), for: .touchUpInside)
            
            
            let CountrySelect = arrSelectedCountry.first{$0.name == "\(countryModel.name)"}
            
            
            cell.btnCheckUncheck.isSelected = CountrySelect != nil ? true : false
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfDissLiked") as! cellOfDissLiked
            
            let countryModel =  arrDisLiked2[indexPath.row]
            
            cell.lblCountry.text = countryModel.name
            cell.btnCheckUncheck.tag = indexPath.row
            cell.btnCheckUncheck.setImage(UIImage.init(named: "uncheck"), for: .normal)
            cell.btnCheckUncheck.setImage(UIImage.init(named: "check"), for: .selected)
            cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClick(_sender:)), for: .touchUpInside)
            
            let CountrySelect = arrSelectedCountry2.first{$0.name == "\(countryModel.name)"}
            
            cell.btnCheckUncheck.isSelected = CountrySelect != nil ? true : false
            
            return cell
            
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

//MARK: - Date Picker
extension BodyInfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        showDatePicker(for: textField)
        
    }
    
    func showDatePicker(for textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        // Set the date picker's target to call a method when the value changes
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        // Set the input view of the text field to the date picker
        textField.inputView = datePicker
        
        // Make the text field become first responder
        textField.becomeFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Format the selected date and set it as the text field's text
        dateField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
}
