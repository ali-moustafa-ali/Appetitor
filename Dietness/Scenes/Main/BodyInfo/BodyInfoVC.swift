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
    
    
    var dislikedClassifications: [DislikedClassification] = []
    
    var selectedDislikedClassifications = [DislikedClassification]()
    
    var allergenItems = [AllergenItem]()
    var selectedAllergenItems = [AllergenItem]()
    
    var userInformation: UserInformation?
    
    var finishedBodyInfoCompletion: ((BodyInfoVC, UserInformation)->Void)?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userInformation = UserInformation(weight: nil, height: nil,
                                          birth_date: nil, gender: nil,
                                          food_system: nil, allergen_id: nil,
                                          excluded_classifications: nil)
        
        dateField.delegate = self
        
        btnRadioAllAction(btnRadioAll[0])
        
        // Usage in viewDidLoad or wherever needed
        styleView(weightView, cornerRadius: 10.0)
        styleView(heightView, cornerRadius: 10.0)
        styleView(dateOfBirth, cornerRadius: 10.0)
        
        confirmButtonOL.layer.cornerRadius = 5 // Adjust the value as needed
        confirmButtonOL.clipsToBounds = true // This ensures the corner radius is applied
        
        
        getDislikedClassifications()
        
        getAllergenItems()
        
    }
    
    
    private func styleView(_ view: UIView, cornerRadius: CGFloat) {
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = cornerRadius
    }
    //MARK: API

    func getDislikedClassifications() {
        self.view.makeToastActivity(.center)
        
        Connect.default.request(MainConnector.getDislikedClassifications).decoded(toType: DislikedClassificationsModel.self).observe { [weak self] (result) in
            guard let self = self else {return}
            self.view.hideToastActivity()
            
            switch result {
    
            case .success(let data):
                print("packages success")
                self.dislikedClassifications = data.result ?? []
                print(self.dislikedClassifications)

                self.tblCheckList.reloadData()

                
                
            case .failure(let error):
                print("packages failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    func getAllergenItems() {
        self.view.makeToastActivity(.center)
        
        Connect.default.request(MainConnector.getAllergens).decoded(toType: AllergensModel.self).observe { [weak self] (result) in
            guard let self = self else {return}
            self.view.hideToastActivity()
            
            switch result {
    
            case .success(let data):
                print("allergenItems success")
                self.allergenItems = data.result ?? []
                print(self.allergenItems)

                self.tblCheckList2.reloadData()

                
                
            case .failure(let error):
                print("allergenItems failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    
    
    // MARK: Actions
    @IBAction func btnRadioAllAction(_ sender: UIButton) {
        
        print("Tag of the clicked button>>>", sender.tag)
        
        userInformation?.gender = "\(sender.tag)"
        
        for btn in btnRadioAll{
            
            if sender.tag == btn.tag{ //Clicked button tag
                btn.setImage(UIImage(named: "ic_On"), for: .normal)
            }else{
                btn.setImage(UIImage(named: "ic_Off"), for: .normal)
            }
        }
        
    }
    
    
    @IBAction func btnCheckUncheckClick(_sender: UIButton){
        _sender.isSelected = !_sender.isSelected
        
        let newSelectedItem = dislikedClassifications[_sender.tag]
        
        var isExist = false
        
        // remove if exists
        for i in 0..<selectedDislikedClassifications.count{
            let item = selectedDislikedClassifications[i]
            
            if item.id == newSelectedItem.id{
                isExist = true
                selectedDislikedClassifications.remove(at: i)
                return
            }
            
        }

        if !isExist{
            selectedDislikedClassifications.append(newSelectedItem)
        }
        
        tblCheckList.reloadData()
        
    }
    
    @IBAction func btnCheckUncheckClick2(_sender: UIButton){
        
        _sender.isSelected = !_sender.isSelected

        let newSelectedItem = allergenItems[_sender.tag]

        var isExist = false

        for i in 0..<selectedAllergenItems.count{

            let item = selectedAllergenItems[i]

            if item.id == newSelectedItem.id{
                isExist = true

                selectedAllergenItems.remove(at: i)

                return
            }
        }

        if !isExist{
            selectedAllergenItems.append(newSelectedItem)
        }

        tblCheckList2.reloadData()
        
    }
    
    private func checkVerification()->Bool{
        
        guard  let weight = weightField.text,
                !weight.isEmpty else{
            
            view.makeToast("Please enter weight")
            
            return false
        }
        
        guard let height = heightField.text,
                !height.isEmpty else{
            
            view.makeToast("Please enter height")
            
            return false
        }
        

        guard let date = dateField.text,
                !date.isEmpty else{
            
            view.makeToast("Please enter date")
            
            return false
        }
        
        guard let gender = userInformation?.gender,
                !gender.isEmpty else{
            
            view.makeToast("Please choose gender")
            
            return false
        }
        
        return true

    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        // pass verifications
        guard checkVerification() else{
            
            return
        }
        
        guard let userInformation = getUserInformation() else{
            
            view.makeToast("Please complete all required data")
            
            return
        }
        
        finishedBodyInfoCompletion!(self, userInformation)
        
    }
    
    private func getUserInformation()->UserInformation?{
        
        if let height = heightField.text,
           let weight = weightField.text,
           let date = dateField.text,
           let gender = userInformation?.gender{
            
            return UserInformation(weight: weight, height: height,
                                   birth_date: date,
                                   gender: gender, food_system: "1",
                                   allergen_id: selectedAllergenItems.map({ String($0.id) }),
                                   excluded_classifications: selectedDislikedClassifications.map({ String($0.id) }))
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
        return tableView == tblCheckList ? dislikedClassifications.count : allergenItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblCheckList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfDissLiked") as! cellOfDissLiked
            
            let dislikedClassificationsModel = dislikedClassifications[indexPath.row]
            
            let title = Helper.language == "ar" ? dislikedClassificationsModel.titleAr : dislikedClassificationsModel.titleEn
            
            
            cell.lblCountry.text = title
            cell.btnCheckUncheck.tag = indexPath.row
            cell.btnCheckUncheck.setImage(UIImage.init(named: "uncheck"), for: .normal)
            cell.btnCheckUncheck.setImage(UIImage.init(named: "check"), for: .selected)
            
            cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClick(_sender:)), for: .touchUpInside)
            
            
            let selectedDislikedClassification = selectedDislikedClassifications.first{$0.id == dislikedClassificationsModel.id}
            
            cell.btnCheckUncheck.isSelected = selectedDislikedClassification != nil ? true : false
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfDissLiked") as! cellOfDissLiked
            
            let allergenItemsModel = allergenItems[indexPath.row]
            
            let title = Helper.language == "ar" ? allergenItemsModel.nameAr : allergenItemsModel.nameEn

            
            cell.lblCountry.text = title
            cell.btnCheckUncheck.tag = indexPath.row
            cell.btnCheckUncheck.setImage(UIImage.init(named: "uncheck"), for: .normal)
            cell.btnCheckUncheck.setImage(UIImage.init(named: "check"), for: .selected)
            cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClick2(_sender:)), for: .touchUpInside)
            
            let selectedAllergenItem = selectedAllergenItems.first{$0.id == allergenItemsModel.id}
            
            cell.btnCheckUncheck.isSelected = selectedAllergenItem != nil ? true : false
            
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
