//
//  OurPackagesVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/14/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit

class OurPackagesVC: UIViewController {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var packagesCollectionView: UICollectionView!
    
    var categories : [Category] = []
    var packages : [Package] = []
    var selectedCategory: Category?
    var products: [Product] = []
    var imageURL = ""
    var catID: Int?
    
    func getCategories() {
        self.view.makeToastActivity(.center)
        Connect.default.request(MainConnector.getCategories).decoded(toType: CategoriesResponse.self).observe { (result)
            in
            self.view.hideToastActivity()
            switch result {
            
            case .success(let data):
                print("categories success")
                self.categories = data.result?.categories ?? []
                self.products = data.result?.categories?.first?.products ?? []
                self.catID = self.categories.first?.id ?? 0
                self.imageURL = data.result?.image_url ?? ""
                self.getPackages(self.catID ?? 0)
                DispatchQueue.main.async {
                    self.categoriesCollectionView.reloadData()
                }
            case .failure(let error):
                print("categories failed")
                self.view.makeToast(error.localizedDescription)
            }
            
        }
    }
    func getPackages(_ id: Int) {
        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }
        self.view.makeToastActivity(.center)
        Connect.default.request(MainConnector.getPackagesById(id: id)).decoded(toType: PackagesResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
            
            case .success(let data):
                print("packages success")
                self.packages = data.result?.packages ?? []
                //                self.imageURL = data.result?.image_url ?? ""
                DispatchQueue.main.async {
                    self.packagesCollectionView.reloadData()
                    
                }
            case .failure(let error):
                print("packages failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCategories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension OurPackagesVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categories.count
        }else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
            if catID == categories[indexPath.row].id ?? 0 {
                cell.categoryNameLabel.backgroundColor = #colorLiteral(red: 0.9895387292, green: 0.8174065948, blue: 0.4158086181, alpha: 1)
                cell.categoryNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else {
                cell.categoryNameLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.categoryNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            cell.categoryNameLabel.text = categories[indexPath.row].name ?? ""
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackagesCell", for: indexPath) as! PackagesCell
            let imgURL = "\(imageURL)/\(products[indexPath.row].image ?? "")"
            if let url = URL(string: imgURL) {
                cell.packageImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "default"))
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            catID = categories[indexPath.row].id
            //                getPackages(catID ?? 0)
            selectedCategory = categories[indexPath.row]
            products = categories[indexPath.row].products ?? []
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
                self.view.makeToastActivity(.center)
                self.packagesCollectionView.reloadData()
                self.view.hideToastActivity()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == packagesCollectionView {
            return CGSize(width:(collectionView.bounds.width/2) - 8, height: 160)
        }else {
            return CGSize(width:(collectionView.bounds.width/2) - 8, height: 50)
        }
    }
    
}
