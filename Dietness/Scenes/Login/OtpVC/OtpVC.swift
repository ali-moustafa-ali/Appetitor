//
//  OtpVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/20/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import StepIndicator
import OTPInputView
import PusherSwift
import MOLH
import OTPFieldView

class AuthRequestBuilder: AuthRequestBuilderProtocol {
    func requestFor(socketID: String, channelName: String) -> URLRequest? {
        var request = URLRequest(url: URL(string: "https://dietnesskw.com/broadcasting/auth")!)
        request.httpMethod = "POST"
        request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
        request.addValue("Bearer \(SettingsManager.manager.getUserToken())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        print("dkhasjhkas")
        print(SettingsManager.manager.getUserToken())
        print(SettingsManager.manager.getUserId())
        return request
    }
}
struct DebugConsoleMessage: Codable {
    let name: String
    let message: String
}
extension OtpVC : PusherDelegate {
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        // print the old and new connection states
        print("old: \(old.stringValue()) -> new: \(new.stringValue())")
    }
    
    func subscribedToChannel(name: String) {
        print("Subscribed to \(name)")
    }
    
    func debugLog(message: String) {
        print(message)
    }
    
    func receivedError(error: PusherError) {
        if let code = error.code {
            print("Received error: (\(code)) \(error.message)")
        } else {
            print("Received error: \(error.message)")
        }
    }
}
class OtpVC: UIViewController {
    
    @IBOutlet weak var stepIndicator: StepIndicatorView!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var checkPhoneLabel: UILabel!
    @IBOutlet weak var weSentYouLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var otpView: OTPFieldView!
    @IBOutlet weak var successfulLabel: UILabel!
    @IBOutlet weak var yourLabel: UILabel!
    @IBOutlet weak var confirmBtnOutlet: UIButton!
    @IBOutlet weak var didntReciveLabel: UILabel!
    @IBOutlet weak var sendAgainBtnOutlet: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var successfullStack: UIStackView!
    @IBOutlet weak var countDownStack: UIStackView!
    
    var phoneCode = ""
    var phone = ""
    var email:String = ""
    var type:String!
    var status:String = "New"
    var comingFrom:String = ""
    weak var timer = Timer()
    var count = 60
    var pusher:Pusher?
    var autoActive:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        //        otpView.delegateOTP = self
        self.phoneLabel.text = phone
        checkPhoneLabel.text = type == "email" ? "check your email".localized:"check your phone".localized
        //        weSentYouLabel.text = type == "email" ? "We have sent a code to the email you entered":"We have sent a code to the phone number you entered"
        countDownStack.isHidden = comingFrom == "signup" ? false:true
        //        if status == "Pending" || status == "Waiting_payment"{
        //            successfullStack.isHidden = false
        //            countDownStack.isHidden = true
        //        }else{
        successfullStack.isHidden = true
        //        }
        setUpPusher()
        self.otpView.fieldsCount = 4
        self.otpView.fieldBorderWidth = 2
        self.otpView.defaultBorderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.otpView.filledBorderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.otpView.cursorColor = UIColor.black
        self.otpView.displayType = .underlinedBottom
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpPusher(){
        //        let options = PusherClientOptions(authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
        //            autoReconnect: true, host: PusherHost.host("https://dietnesskw.com/broadcasting/auth"))
        let options = PusherClientOptions(authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),host: .cluster("eu"))
        AppDelegate.pusher = Pusher(key: "1768dc976f53c7879607", options: options)
        AppDelegate.pusher.delegate = self
        AppDelegate.pusher.connection.delegate = self
        AppDelegate.pusher?.subscribe("private-user_notify-\(SettingsManager.manager.getUserId())").bind(eventName: "Waiting_payment", eventCallback: { (event) in
            if event.data != nil {
                let vc:PaymentVC = PaymentVC.instantiate(appStoryboard: .login)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        AppDelegate.pusher?.connect()
    }
    
    @objc func updateTime() {
        
        if (count <= 60 && count > 0)
        {
            count = count - 1
            countDownLabel.text =   "0:\(count)"
            sendAgainBtnOutlet.isEnabled = false
        }
        else
        {
            sendAgainBtnOutlet.isEnabled = true
            countDownLabel.text =   "0:\(count)"
        }
    }
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmBtnAction(_ sender: Any) {
        //        successfullStack.isHidden = false
        //        countDownStack.isHidden = true
    }
    
    fileprivate func resend(completion:@escaping (Bool)->()) {
        self.view.makeToastActivity(.center)
        Connect.default.request(RegisterationConnector.resend).dictionary().observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let response):
                completion(true)
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
                completion(false)
                return
            }
        }
    }
    
    @IBAction func resend(_ sender:Any){
        count = 60
        resend { (success) in
            if success{
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo:nil , repeats: true)
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
extension OtpVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.view.makeToastActivity(.center)
        if self.comingFrom == "signup" {
            Connect.default.request(RegisterationConnector.verifyOtp(otp: otpString, emailOrMobile: type == "email" ? email:phone, type: type, code: phoneCode)).decoded(toType: OtpResponse.self).observe { (result) in
                self.view.hideToastActivity()
                switch result{
                case .success(let response):
                    if response.error_flag == 0 {
                        if self.comingFrom == "signup"{
                            self.successfullStack.isHidden = false
                            self.countDownStack.isHidden = true
                            self.otpView.isHidden = true
                            if self.autoActive! {
                                let vc:PaymentVC = PaymentVC.instantiate(appStoryboard: .login)
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }else{
                            let vc:NewPasswordVC = NewPasswordVC.instantiate(appStoryboard: .login)
                            vc.otp = otpString
                            vc.type = self.type
                            vc.code = self.phoneCode
                            vc.emailOrPhone = self.type == "email" ? self.email:self.phone
                            self.present(vc, animated: true, completion: nil)
                        }
                    }else {
                        self.view.makeToast("OTP error".localized)
                    }
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                    return
                }
            }
        }else {
            Connect.default.request(RegisterationConnector.verifyOtpForget(otp: otpString, emailOrMobile: type == "email" ? email:phone, type: type, code: phoneCode)).decoded(toType: OtpForgetResponse.self).observe { (result) in
                self.view.hideToastActivity()
                switch result{
                case .success(let response):
                    if response.error_flag == 0 {
                        if self.comingFrom == "signup"{
                            self.successfullStack.isHidden = false
                            self.countDownStack.isHidden = true
                            self.otpView.isHidden = true
                        }else{
                            self.view.makeToast(response.message ?? "")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                let vc:NewPasswordVC = NewPasswordVC.instantiate(appStoryboard: .login)
                                vc.otp = otpString
                                vc.type = self.type
                                vc.code = self.phoneCode
                                vc.emailOrPhone = self.type == "email" ? self.email:self.phone
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }else {
                        self.view.makeToast("OTP error".localized)
                    }
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                    return
                }
            }
        }
    }
}

