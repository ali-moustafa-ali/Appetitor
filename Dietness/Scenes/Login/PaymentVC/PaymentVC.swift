//
//  PaymentVC.swift
//  Dietness
//
//  Created by karim metawea on 2/14/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import Alamofire
//import goSellSDK
import MFSDK

class PaymentVC: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberLabel.text = (SettingsManager.manager.getCountryCode() ?? "") + (SettingsManager.manager.getPhoneNumber())
    }
    
    
    @IBAction func payButtonClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Payment Method".localized, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "KNET".localized, style: .default, handler: { _ in
            self.makePayment(paymentMethodId: 1)
        }))
        
        alert.addAction(UIAlertAction(title: "Bank Cards".localized, style: .default, handler: { _ in
            self.makePayment(paymentMethodId: 2)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func makePayment(paymentMethodId: Int) {
        
        let invoiceValue: Decimal = Decimal(string: SettingsManager.manager.getSelectedPlan()?.price ?? "0")!
        
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: paymentMethodId)
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: Helper.language == "ar" ? .arabic : .english) { [weak self] (response, invoiceId) in
            
            print("MF Response:", response)
            switch response {
            case .success(let executePaymentResponse):
                print("\(executePaymentResponse.invoiceStatus ?? "")")
                // call check status api
                self?.checkPayment(executePaymentResponse: executePaymentResponse)
            case .failure(let failError):
                print(failError.errorDescription)
                self?.view.makeToast("Faild Payment")
            }
        }
    }
    func checkPayment(executePaymentResponse: MFPaymentStatusResponse) {
        let comments = "\(SettingsManager.manager.getSelectedPackage()?.id ?? 0)-\(SettingsManager.manager.getSelectedPlan()?.id ?? 0)-\(SettingsManager.manager.getUserId())"
        let newObject = PaymentModel(InvoiceId: executePaymentResponse.invoiceID, InvoiceStatus: executePaymentResponse.invoiceStatus, InvoiceReference: executePaymentResponse.invoiceReference, CustomerReference: executePaymentResponse.customerReference, CreatedDate: executePaymentResponse.createdDate, ExpiryDate: executePaymentResponse.expiryDate, InvoiceValue: executePaymentResponse.invoiceValue, Comments: comments, CustomerName: executePaymentResponse.customerName, CustomerMobile: executePaymentResponse.customerMobile, CustomerEmail: executePaymentResponse.customerEmail, UserDefinedField: executePaymentResponse.userDefinedField, InvoiceDisplayValue: executePaymentResponse.invoiceDisplayValue, InvoiceItems: executePaymentResponse.invoiceItems, InvoiceTransactions: executePaymentResponse.invoiceTransactions, Suppliers: executePaymentResponse.suppliers)
        Connect.default.request(RegisterationConnector.payment(executePaymentResponse: newObject)).dictionary().observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                print(data)
                SettingsManager.manager.setCurrentStatus(value: "Active")
                SettingsManager.manager.setSubiscribtion(value: CurrentSubscription(id: nil, user: nil, package: "\(SettingsManager.manager.getSelectedPackage()?.id ?? 0)", plan:"\(SettingsManager.manager.getSelectedPlan()?.id ?? 0)",from: nil, to: nil, amount: nil, status: "Active", approved_at: nil))
                let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                let vc = UIStoryboard(name: "Tab", bundle: nil).instantiateInitialViewController()
                rootviewcontroller.rootViewController = vc
                rootviewcontroller.makeKeyAndVisible()
                self.view.makeToast("Success")
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
}
struct PaymentModel: Codable {
    let InvoiceId: Int?
    let InvoiceStatus: String?
    let InvoiceReference: String?
    let CustomerReference: String?
    let CreatedDate: String?
    let ExpiryDate: String?
    let InvoiceValue: Decimal?
    let Comments: String?
    let CustomerName: String?
    let CustomerMobile: String?
    let CustomerEmail: String?
    let UserDefinedField: String?
    let InvoiceDisplayValue: String?
    let InvoiceItems: [MFInvoiceItem]?
    let InvoiceTransactions: [MFInvoiceTransaction]?
    let Suppliers: [MFSupplier]?
}

//struct InvoiceTransactionsModel: Codable {
//    let TransactionDate: String?
//    let PaymentGateway: String?
//    let ReferenceId: String?
//    let TrackId: String?
//    let TransactionId: String?
//    let PaymentId: String?
//    let AuthorizationId: String?
//    let TransactionStatus: String?
//    let TransationValue: String?
//    let CustomerServiceCharge: String?
//    let DueValue: String?
//    let PaidCurrency: String?
//    let PaidCurrencyValue: String?
//    let Currency: String?
//    let Error: String?
//    let CardNumber: String?
//    let ErrorCode: String?
//}
