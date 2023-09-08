//
//  AddressVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/17/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import iOSDropDown
import JVFloatLabeledTextField
import MapKit
import MOLH


class AddressVC: UIViewController , RecieveLocation{
    func passLocationBack(government: String, city: String, street: String, lat: String, lng Lng: String) {
        self.governorateField.text = government
        self.regionField.text = city
        self.streetField.text = street
        self.userLat = Double(lat)
        self.userLong = Double(Lng)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deliveryTimeView: UIView!
    @IBOutlet weak var amImage: UIImageView!
    @IBOutlet weak var pmImage: UIImageView!
    @IBOutlet weak var governorateField: DropDown!
    @IBOutlet weak var regionField: DropDown!
    @IBOutlet weak var pieceField: JVFloatLabeledTextField!
    @IBOutlet weak var streetField: JVFloatLabeledTextField!
    @IBOutlet weak var avenueField: JVFloatLabeledTextField!
    @IBOutlet weak var houseField: JVFloatLabeledTextField!
    @IBOutlet weak var floorField: JVFloatLabeledTextField!
    @IBOutlet weak var flatField: JVFloatLabeledTextField!
    @IBOutlet weak var notesField: JVFloatLabeledTextView!
    @IBOutlet weak var mapBtnOutlet: UIButton!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var notes: UILabel!

    var callbackClosure: (() -> Void)?
    var cities: [Governate] = []
    var regions: [City] = []
    var didAddAddress:(()->())?
    var new = true
    var address: Address?
    var selectedGov: Int?
    var selectedRegion: Int?
    var userLat: Double?
    var userLong: Double?
    var locationManager = CLLocationManager()
    var showDeliverySwitch:Bool?
    var note:String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCities()
        print("user latitude = \(UserDefaults.standard.double(forKey: "Lat"))")
        print("user longitude = \(UserDefaults.standard.double(forKey: "Long"))")
        // check firstView if it will be hidden or not
        deliveryTimeView.isHidden = true
        if showDeliverySwitch ?? false {
            deliveryTimeView.isHidden = false
        }
        self.notes.text = self.note
    }
    override func viewWillDisappear(_ animated: Bool) {
        callbackClosure?()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateDeliveryTime(time: "AM")
        self.amImage.alpha = 1
        self.pmImage.alpha = 0
        //
        if MOLHLanguage.currentAppleLanguage() == "en" {
            self.governorateField.text = address?.governorate?.name_en ?? ""
            self.regionField.text = address?.region?.name_en ?? ""
        }else {
            self.governorateField.text = address?.governorate?.name_ar ?? ""
            self.regionField.text = address?.region?.name_ar ?? ""
        }
        self.pieceField.text = address?.piece ?? ""
        self.streetField.text = address?.street ?? ""
        self.avenueField.text = address?.avenue ?? ""
        self.houseField.text = address?.house ?? ""
        self.floorField.text = address?.floor ?? ""
        self.flatField.text = address?.flat ?? ""
        self.notesField.text = address?.notes ?? ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getCities() {
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.getCities).decoded(toType: CitiesResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
            
            case .success(let data):
                print("cities success")
                self.cities = data.result?.governates ?? []
                var govs = [String]()
                var regs = [String]()
                for city in self.cities {
                    govs.append(city.title ?? "")
                    for gov in city.cities ?? [] {
                        regs.append(gov.title ?? "")
                    }
                }
                DispatchQueue.main.async {
                    //                    self.governorateField.text = govs.first
                    //                    self.regionField.text = regs.first
                    self.selectedGov = self.cities.first?.id ?? 0
                    self.selectedRegion = self.cities.first?.cities?.first?.id ?? 0
                    self.governorateField.optionArray = govs
                    self.governorateField.selectedRowColor = UIColor.lightGray
                    self.governorateField.checkMarkEnabled = false
                    self.governorateField.didSelect{(selectedText , index ,id) in
                        self.governorateField.text = selectedText
                        self.selectedGov = self.cities[index].id ?? 0
                        print("selected gov ID: \(self.selectedGov ?? 0)")
                        self.regions = self.cities.first(where: {$0.id == self.selectedGov})?.cities ?? []
                        regs = []
                        for gov in self.regions {
                            regs.append(gov.title ?? "")
                        }
                        self.regionField.text = regs.first
                        self.regionField.optionArray = regs
                        self.regionField.selectedRowColor = UIColor.lightGray
                        self.regionField.checkMarkEnabled = false
                        self.regionField.didSelect{(selectedText , index ,id) in
                            self.regionField.text = selectedText
                            self.selectedRegion = self.regions[index].id ?? 0
                            print("selected region ID: \(self.selectedRegion ?? 0)")
                        }
                        
                    }
                }
            case .failure(let error):
                print("cities failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    func addAddress(){
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.addAddress(country: governorateField.text ?? "", governorate: "\(selectedGov ?? 0)", region: "\(selectedRegion ?? 0)", piece: pieceField.text ?? "", street: streetField.text ?? "", avenue: avenueField.text ?? "", house: houseField.text ?? "", floor: floorField.text ?? "", flat: flatField.text ?? "", notes: notesField.text ?? "", lat: "\(userLat ?? 0)", lng: "\(userLong ?? 0)")).decoded(toType: DefaultResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                if data.error_flag == 0 {
                    print("address success")
                    DispatchQueue.main.async {
                        self.view.makeToast(data.result?.message ?? "Success")
                        //                    self.pieceField.text = ""
                        //                    self.streetField.text = ""
                        //                    self.avenueField.text = ""
                        //                    self.houseField.text = ""
                        //                    self.floorField.text = ""
                        //                    self.flatField.text = ""
                        //                    self.notesField.text = ""
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismiss(animated: true) {
                            self.didAddAddress?()
                        }
                    }
                }else {
                    print("address failed")
                    self.view.makeToast("address failed")
                }
                
            case .failure(let error):
                print("address failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    func changeAddress(){
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.updateAddress(country: governorateField.text ?? "", governorate: "\(selectedGov ?? 0)", region: "\(selectedRegion ?? 0)", piece: pieceField.text ?? "", street: streetField.text ?? "", avenue: avenueField.text ?? "", house: houseField.text ?? "", floor: floorField.text ?? "", flat: flatField.text ?? "", notes: notesField.text ?? "", lat: "\(userLat ?? 0)", lng: "\(userLong ?? 0)")).decoded(toType: DefaultResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                if data.error_flag == 0 {
                    print("address success")
                    DispatchQueue.main.async {
                        self.view.makeToast(data.result?.message ?? "Success")
                        //                    self.pieceField.text = ""
                        //                    self.streetField.text = ""
                        //                    self.avenueField.text = ""
                        //                    self.houseField.text = ""
                        //                    self.floorField.text = ""
                        //                    self.flatField.text = ""
                        //                    self.notesField.text = ""
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismiss(animated: true) {
                            self.didAddAddress?()
                        }
                    }
                }else {
                    print("address failed")
                    self.view.makeToast("address failed")
                }
                
            case .failure(let error):
                print("address failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    @IBAction func mapBtnAction(_ sender: Any) {
        let popUpStoryBoards = UIStoryboard(name: "Tab", bundle: nil)
        let vc = popUpStoryBoards.instantiateViewController(identifier: "MapVC") as! MapVC
        vc.modalPresentationStyle = .automatic
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if new == true {
            addAddress()
        }else {
            changeAddress()
        }
    }
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectedTime(_ sender: UIButton) {
        if sender.tag == 0 {
            // AM
            self.updateDeliveryTime(time: "AM")
            self.amImage.alpha = 1
            self.pmImage.alpha = 0
        }else if sender.tag == 1 {
            // PM
            self.updateDeliveryTime(time: "PM")
            self.amImage.alpha = 0
            self.pmImage.alpha = 1
        }
    }
    func updateDeliveryTime(time:String){
        // call the APi
        Connect.default.request(TabConnector.sendDeliveryTime(time: time)).decoded(toType: DefaultResponse.self).observe { (result) in
            switch result{
            case .success(let data):
                if data.error_flag == 0 {
                    print(data)
                }else {
                    print("address failed")
                }
            case .failure(let error):
                print("address failed",error)
            }
        }

    }
}
extension AddressVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
        }else {
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        self.userLat = userLocation.coordinate.latitude
        self.userLong = userLocation.coordinate.longitude
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR!")
    }
}
