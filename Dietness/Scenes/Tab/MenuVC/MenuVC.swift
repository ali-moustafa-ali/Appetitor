//
//  MenuVC.swift
//  Dietness
//
//  Created by karim metawea on 2/17/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import FSCalendar

class MenuVC: UIViewController {
    
    
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var deleteOrderButton: UIButton!
    
    var fresh = true
    var fridays:[String] = []
    var restrictedDays:[String] = []
    var reservedDays:[String] = []
    var completedDays:[String] = []
    var remainigDays:[String] = []
    var startDay:String = DateUtils.getDateString(date: Date(), dateFormat: "dd-MM-yyyy")
    var endDay:String = DateUtils.getDateString(date: Date().addingTimeInterval((30*24*60*60)), dateFormat: "dd-MM-yyyy")
    var selectedDay:String?
    var firstDataLoading = true
    var categories:[Category] = []
    var url = ""
    var autoUnSelect = false
    var selectedOrderIDs:[Int] = []
    var count = 0
    var packages:[Package]?
    var selectedPlan:Plan?
    var canChangeSelection = false
    var req: OrderRequest?
    var cartItems:[CartItem] = []

    var maxCount:Int{
        let breakfastQuantity = selectedPlan?.categories?[0].qty?.intValue
        let lunchQuantity = selectedPlan?.categories?[1].qty?.intValue
        
        return (breakfastQuantity ?? 0) + (lunchQuantity ?? 0)
    }
    
    //    let group:DispatchGroup = DispatchGroup()
    
    var formatter:DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en")
        return formatter
    }
    
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuCollectionView.isUserInteractionEnabled = false

        self.userNameLabel.text = "\(SettingsManager.manager.getFirstName()) \(SettingsManager.manager.getLastName())"
        
        menuCollectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [NSKeyValueObservingOptions.new], context: nil)
        selectedDay = DateUtils.getDateString(date: calender.today!, dateFormat: "yyyy-MM-dd")
        print("SELECTED day: \(selectedDay ?? "")")
        
        calender.delegate = self
        calender.dataSource = self
        orderButton.isHidden = true
        deleteOrderButton.isHidden = true
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.allowsMultipleSelection = true
        calender.appearance.todayColor = .clear
        calender.appearance.titleTodayColor = UIColor.PrimaryColor
        self.calender.firstWeekday = 6
        refreshClaender()
    }
    
    override func viewWillLayoutSubviews() {
        collectionViewHeight.constant = menuCollectionView.contentSize.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UICollectionView.contentSize),
           let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            collectionViewHeight.constant = contentSize.height
        }
    }
    func refreshClaender(){
        let fetchGroup = DispatchGroup()
        
        self.view.makeToastActivity(.center)
        getRestrictedDates(group: fetchGroup)
        getReservedDates(group: fetchGroup)
        getRemainingBoxes(group: fetchGroup)
        getItems(group: fetchGroup)
        getPackages(group: fetchGroup)
        
        fetchGroup.notify(queue: .main) {
            self.view.hideToastActivity()
            self.fridays =  self.dates(startDate: self.startDay , endDate: self.endDay, weekday: 6)
            self.calender.reloadData()
            self.menuCollectionView.reloadData()
            for package in (self.packages ?? []) {
                print(SettingsManager.manager.getCurrentSubiscription())
                if "\(package.id ?? 0)" == SettingsManager.manager.getCurrentSubiscription()?.package {
                    self.selectedPlan = package.plans?.first(where: { (plan) -> Bool in
                        "\(plan.id ?? 0)" == SettingsManager.manager.getCurrentSubiscription()?.plan
                    })
                }
            }
        }
    }
    
    func getRestrictedDates(group:DispatchGroup){
        group.enter()
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.getUserRestrictedDays).decoded(toType: DatesResponse.self).observe { (result) in
            group.leave()
            switch result{
            case .success(let data):
                print(data)
                let formattedDates = data.result?.dates?.map({
                    DateUtils.convertDateFormat(dateString: $0, sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy")
                })
                self.restrictedDays = formattedDates ?? []
            case .failure(_):
                return
            }
        }
    }
    
    func getReservedDates(group:DispatchGroup){
        group.enter()
        Connect.default.request(TabConnector.getUserReservedDays).decoded(toType: DatesResponse.self).observe { (result) in
            group.leave()
            switch result{
            case .success(let data):
                print(data)
                let completedDates = data.result?.completed?.map({
                    DateUtils.convertDateFormat(dateString: $0, sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy")
                })
                let reserved = data.result?.dates?.map({
                    DateUtils.convertDateFormat(dateString: $0, sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy")
                })
                self.completedDays = completedDates ?? []
                self.reservedDays = reserved ?? []
                self.calender.reloadData()
                print("reserved days \n \(self.reservedDays)")
            case .failure(_):
                return
            }
        }
    }
    
    func getItems(group:DispatchGroup?,showIndicator: Bool = false){
        group?.enter()
        if showIndicator {
            self.view.makeToastActivity(.center)
        }
        Connect.default.request(TabConnector.getCategories(day: selectedDay ?? "")).decoded(toType: CategoriesResponse.self).observe { (result) in
            group?.leave()
            if showIndicator {
                self.view.hideToastActivity()
            }
            switch result{
            case .success(let data):
                print("CATEGORIES SUCCESS")
                self.categories = data.result?.categories ?? []
                if self.firstDataLoading && self.categories.count > 0 {
                    for myCategorIndex in 0..<(self.categories.count){
                        for myProductIndex in 0..<(self.categories[myCategorIndex].products?.count ?? 0) {
                            self.categories[myCategorIndex].products?[myProductIndex].isSelected = false
                        }
                    }
                    self.firstDataLoading = false
                }
                self.url = data.result?.image_url ?? ""
                self.menuCollectionView.reloadData()
                if showIndicator {
                    self.getOrderByDay()
                }
            case .failure(let error):
                print("CATEGORIES FAILED")
                print(error)
            }
        }
    }
    
    func getPackages(group:DispatchGroup) {
        group.enter()
        Connect.default.request(MainConnector.getUpdatedPackages).decoded(toType: PackagesResponse.self).observe { (result) in
            group.leave()
            switch result {
            case .success(let data):
                self.packages = data.result?.packages ?? []
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    func getRemainingBoxes(group:DispatchGroup) {
        group.enter()
        Connect.default.request(TabConnector.getRemainingBoxes).decoded(toType: RemainingBoxesResponse.self).observe { (result) in
            group.leave()
            switch result {
            case .success(let data):
                print(data)
                if let data = data.result{
                    let from =  DateUtils.convertDateFormat(dateString: String(data.from?.dropLast(17) ?? ""), sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy", locale: "en")
                    self.startDay = from
                    let to = DateUtils.convertDateFormat(dateString: String(data.to?.dropLast(17) ?? ""), sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy", locale: "en")
                    self.endDay = to
                    self.remainigDays = self.dates(startDate: from, endDate: to)
                    if self.remainigDays.count != 0 {
                        self.calender.deselect(self.calender.selectedDate ?? Date())
                        let currentDate = self.calender.selectedDate ?? Date()

                        self.calender.deselect(currentDate)
                        
                        var dateComponent = DateComponents()
                        dateComponent.day = 0
                        
                        var nextDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
                        
                        if nextDate.isFriday() {
                            dateComponent.day = 2
                            nextDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
                        }
                        
                        self.calender.select(nextDate)
                        
                        self.selectedDay = DateUtils.getDateString(date: nextDate, dateFormat: "yyyy-MM-dd")

//                        self.selectedDay = DateUtils.convertDateFormat(dateString: self.remainigDays[0], sourceFormat: "dd-MM-yyyy", destinationFormat: "yyyy-MM-dd", locale: "en")
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.locale = Locale(identifier: "en")
//                        dateFormatter.dateFormat = "yyyy-MM-dd"
//                        let date = dateFormatter.date(from: self.selectedDay ?? "")!
//                        self.calender.select(date)
                        self.getOrderByDay()
                        self.getItems(group: nil,showIndicator: true)
                    }
                }
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    func getOrderByDay(){
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.getOrderByDay(day: self.selectedDay ?? "")).decoded(toType: GetOrderByDayResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
            case .success(let data):
                if let data = data.result{
                    let orderitems = data.order.items
                    for orderItemIndex in 0..<(orderitems?.count ?? 0){
                        let orderItemCategory = orderitems?[orderItemIndex].category
                        let orderItemProducts = orderitems?[orderItemIndex].products
                        for myCategorIndex in 0..<(self.categories.count){
                            if self.categories[myCategorIndex].id == orderItemCategory?.id{
                                for myProductIndex in 0..<(self.categories[myCategorIndex].products?.count ?? 0) {
                                    for orderProductIndex in 0..<(orderItemProducts?.count ?? 0) {
                                        if orderItemProducts?[orderProductIndex].id == self.categories[myCategorIndex].products?[myProductIndex].id {
                                            self.categories[myCategorIndex].products?[myProductIndex].isSelected = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.menuCollectionView.reloadData()
                    }
                }else{
                }
            case .failure( _):
                self.view.makeToast("Please choose your meal for today".localized)
            }
        }
    }
    func dates(startDate:String,endDate: String, weekday: Int? = nil) -> [String] {
        Formatter.date.locale = Locale(identifier: "en")
        Formatter.date.dateFormat = "dd-MM-yyyy"
        // first get the endDate
        guard var endDate = Formatter.date.date(from: endDate) else { return [] }
        guard let startDate = Formatter.date.date(from: startDate) else { return [] }
        // for calendrical calculations you should use noon time
        endDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: endDate)!
        // lets get todays noon time to start
        var date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: startDate)!
        var dates: [String] = []
        // while date less than or equal to end date
        while date <= endDate {
            if weekday == nil {
                dates.append(Formatter.date.string(from: date))
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            } else if let weekday = weekday, Calendar.current.component(.weekday, from: date) == weekday {
                // add the formatted date to the array
                dates.append(Formatter.date.string(from: date))
                date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date)!
            } else {
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }
        }
        return dates
    }
    @IBAction func order(_ sender: Any) {
        self.categories.forEach { (Category) in
            let cID = Category.id
            var ids:[Int] = []
            Category.products?.forEach({ (Product) in
                if Product.isSelected ?? false {
                    ids.append(Product.id ?? 0)
                }
            })
            if ids.count < 1 {
                self.view.makeToast("please select items to order")
                return
            }
            self.cartItems.append(CartItem(category: cID ?? 0, products: ids))
        }
        self.view.makeToastActivity(.center)
        DietnessServices.addOrder(day: selectedDay ?? "", items: self.cartItems) {
            (response, orderError, error) in
            self.view.hideToastActivity()
            print(response as Any)
            if response != nil && error == nil{
                if response?.error_flag == 0 {
                    self.cartItems = []
                    self.menuCollectionView.isUserInteractionEnabled = true
                    self.reservedDays.append(DateUtils.convertDateFormat(dateString: self.selectedDay ?? "", sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy"))
                    self.view.makeToast("Ordered Successfuly".localized)
                    self.calender.reloadData()
                    self.menuCollectionView.reloadData()
                    
                    if DateUtils.getDateString(date: self.calender.maximumDate, dateFormat: "yyyy-MM-dd") == self.selectedDay {
                        self.menuCollectionView.isUserInteractionEnabled = false
                        self.orderButton.isHidden = true
                        self.deleteOrderButton.isHidden = false
                        return
                    }
                    let currentDate = self.calender.selectedDate ?? Date()

                    self.calender.deselect(currentDate)
                    
                    var dateComponent = DateComponents()
                    dateComponent.day = 1
                    
                    var nextDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
                    
                    if nextDate.isFriday() {
                        dateComponent.day = 2
                        nextDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
                    }
                    
                    self.calender.select(nextDate)
                    
                    self.selectedDay = DateUtils.getDateString(date: nextDate, dateFormat: "yyyy-MM-dd")
                    self.getItems(group: nil)
                    self.getOrderByDay()

                    self.scrollView.setContentOffset(.zero, animated: true)
                }else {
                    self.view.makeToast(response?.message ?? "")
                }
            }else if orderError != nil && error == nil {
                self.view.makeToast(orderError?.message ?? "")
                
            }else {
                self.view.makeToast(error?.localizedDescription)
                
            }
        }
    }
    
    
    @IBAction func deleteOrderButtonClicked(_ sender: UIButton) {
        
        view.makeToastActivity(.center)
        
        
        let orderDay = DateUtils.convertDateFormat(dateString: self.selectedDay ?? "", sourceFormat: "dd-MM-yyyy", destinationFormat: "yyyy-MM-dd")
        
        print("order day is", orderDay)
        
        Connect.default.request(TabConnector.deleteOrder(day: orderDay)).decoded(toType: DefaultResponse.self).observe { (result) in
            
            self.view.hideToastActivity()
            
            switch result{
            case .success(let data):
                print("delete order success")
                if data.error_flag == 0 {
                    for myCategorIndex in 0..<(self.categories.count){
                        for myProductIndex in 0..<(self.categories[myCategorIndex].products?.count ?? 0) {
                            self.categories[myCategorIndex].products?[myProductIndex].isSelected = false
                        }
                    }
                    self.menuCollectionView.isUserInteractionEnabled = true
                    DispatchQueue.main.async {
                        self.menuCollectionView.reloadData()
                        self.view.makeToast(data.result?.message ?? "Order Deleted Successfully".localized)
                        self.reservedDays = self.reservedDays.filter { $0 != DateUtils.convertDateFormat(dateString: self.selectedDay ?? "", sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy") }
                        self.calender.reloadData()
                        self.orderButton.isHidden = false
                        self.deleteOrderButton.isHidden = true
                    }
                }else {
                    self.view.makeToast(data.result?.message ?? "Deleting Order Failed".localized)
                }
            case .failure(let error):
                print("delete order failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
}

extension MenuVC:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        print(formatter.string(from: date))
        cartItems = []
        self.selectedDay = DateUtils.getDateString(date: date, dateFormat: "yyyy-MM-dd")
        let selected = DateUtils.getDateString(date: date, dateFormat: "dd-MM-yyyy")
        let afterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        if date.endOfDay > afterTomorrow.endOfDay && !reservedDays.contains(selected) && !restrictedDays.contains(selected){
            self.menuCollectionView.isUserInteractionEnabled = true
            orderButton.isHidden = false
            deleteOrderButton.isHidden = true
        }else if date.endOfDay > afterTomorrow.endOfDay && reservedDays.contains(selected) && !restrictedDays.contains(selected){
            self.menuCollectionView.isUserInteractionEnabled = false
            orderButton.isHidden = true
            deleteOrderButton.isHidden = false
        }
        
        if date.endOfDay <= afterTomorrow.endOfDay || completedDays.contains(selected) || restrictedDays.contains(selected) || (date.endOfDay > afterTomorrow.endOfDay && !reservedDays.contains(selected) && restrictedDays.contains(selected)) {
            orderButton.isHidden = true
            deleteOrderButton.isHidden = true
        }
        count = 0
        //        menuCollectionView.reloadData()
        getItems(group: nil,showIndicator: true)
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return DateUtils.getDate(dateString: startDay, dateFormat: "dd-MM-yyyy")
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return DateUtils.getDate(dateString: endDay, dateFormat: "dd-MM-yyyy")
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        if restrictedDays.contains(formatter.string(from: date)) , date.isFriday() == false{
            return UIImage(named: "FreezeIcon")
        }
        if completedDays.contains(formatter.string(from: date)) , date.isFriday() == false{
            return UIImage(named: "tick")
        }
        return  nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if reservedDays.contains(formatter.string(from: date)), date.isFriday() == false && !completedDays.contains(formatter.string(from: date)) , date.isFriday() == false {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.PrimaryColor!]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if fridays.contains(formatter.string(from: date)){
            return .lightGray
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if fridays.contains(formatter.string(from: date)){
            return false
        }
        if remainigDays.contains(formatter.string(from: date)){
            return true
        }
        return false
    }
    
}

extension MenuVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CustomHeaderViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories[section].products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.configureCell(product: (self.categories[indexPath.section].products?[indexPath.row])!,url:url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.size.width) / 2 )
        let height =  CGFloat(exactly: 260)!
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuHeader", for: indexPath) as! MenuHeader
        view.header.text = categories[indexPath.section].name
        view.section = indexPath.section
        view.delegate = self
        
        if indexPath.section == 0 , reservedDays.contains(DateUtils.convertDateFormat(dateString: selectedDay ?? "", sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy")) == false {
            if let selectedDay = selectedDay, restrictedDays.contains(DateUtils.convertDateFormat(dateString: selectedDay, sourceFormat: "yyyy-MM-dd", destinationFormat: "dd-MM-yyyy")){
                view.freezeButton.setTitle("UnFreeze", for: .normal)
                view.isFreezed = true
            }else{
                view.freezeButton.setTitle("Freeze", for: .normal)
                view.isFreezed = false
            }
            view.freezeButton.isHidden = false
        }else{
            view.freezeButton.isHidden = true
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // selection
        for myCategorIndex in 0..<(self.categories.count){
            if indexPath.section == myCategorIndex {
                for myProductIndex in 0..<(self.categories[myCategorIndex].products?.count ?? 0) {
                    if indexPath.row == myProductIndex {
                        if (self.categories[myCategorIndex].products?[myProductIndex].isSelected == nil) || (self.categories[myCategorIndex].products?[myProductIndex].isSelected == false) {
                            self.categories[myCategorIndex].products?[myProductIndex].isSelected = true
                            print("selected")
                        }else {
                            self.categories[myCategorIndex].products?[myProductIndex].isSelected = false
                            print("not selected")
                        }
                    }
                }
            }
            collectionView.reloadSections(IndexSet(integer: indexPath.section))
        }
        // scrolling
        var counter = 0
        for myProductIndex in 0..<(self.categories[indexPath.section].products?.count ?? 0) {
            let status = (self.categories[indexPath.section].products?[myProductIndex].isSelected)
            if status ?? false {
                counter += 1
            }
        }
        var breakFastCounter = 0
        for myProductIndex in 0..<(self.categories[0].products?.count ?? 0) {
            let status = (self.categories[0].products?[myProductIndex].isSelected)
            if status ?? false {
                breakFastCounter += 1
            }
        }
        if indexPath.section < self.categories.count - 1 {
            if counter == (selectedPlan?.categories?[indexPath.section].max?.intValue ?? 0){
                let attributes = self.menuCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.section + 1))
                self.scrollView.setContentOffset(CGPoint(x: 0, y: attributes!.frame.origin.y - self.menuCollectionView.contentInset.top), animated: true)
            }else if breakFastCounter == 1 && counter == (selectedPlan?.categories?[indexPath.section].qty?.intValue ?? 0) && selectedPlan?.categories?[indexPath.section].category?.name == "main course" {
                let attributes = self.menuCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.section + 1))
                self.scrollView.setContentOffset(CGPoint(x: 0, y: attributes!.frame.origin.y - self.menuCollectionView.contentInset.top), animated: true)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var ids:[Int] = []
        let selectedItem =  self.categories[indexPath.section].products?[indexPath.row]
        for myCategorIndex in 0..<(self.categories.count){
            if indexPath.section == myCategorIndex {
                self.categories[myCategorIndex].products?.forEach({ (product) in
                    if product.isSelected ?? false {
                        ids.append(product.id ?? 0)
                    }
                })
            }
        }
        // check if same item selected
        if selectedItem?.isSelected == true
        {
            return true
        }
        
        // handle 3 or 2 launch
        var counter = 0
        for myProductIndex in 0..<(self.categories[indexPath.section].products?.count ?? 0) {
            let status = (self.categories[indexPath.section].products?[myProductIndex].isSelected)
            if status ?? false {
                counter += 1
            }
        }
        var breakFastCounter = 0
        for myProductIndex in 0..<(self.categories[0].products?.count ?? 0) {
            let status = (self.categories[0].products?[myProductIndex].isSelected)
            if status ?? false {
                breakFastCounter += 1
            }
        }
        if breakFastCounter == 1 && ids.count == (selectedPlan?.categories?[indexPath.section].qty?.intValue ?? 0) && selectedPlan?.categories?[indexPath.section].category?.name == "main course"
        {
            return false
        }

        
        // result
        if ids.count < (selectedPlan?.categories?[indexPath.section].max?.intValue ?? 0)
        {
            return true
        }else{
            return false
        }
    }
    
    func freezeDay(isFreezed:Bool){
        guard let selectedDay = selectedDay else {return}
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.freeze(day: selectedDay  , isFreezed: isFreezed)).dictionary().observe { (result) in
            switch result {
            case .success(let _):
                self.view.hideToastActivity()
                self.refreshClaender()
            case .failure(let error):
                self.view.hideToastActivity()
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
}






extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func isFriday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 6
    }
}
