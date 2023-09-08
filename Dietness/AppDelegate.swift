//
//  AppDelegate.swift
//  Dietness
//
//  Created by karim metawea on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
//import goSellSDK
import MOLH
import IQKeyboardManagerSwift
import PusherSwift
import OTPInputView
import FirebaseMessaging
import UserNotifications
import MFSDK
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable{
    static var pusher: Pusher!
    static var channel: PusherChannel!
    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let vc = UIStoryboard(name: "Tab", bundle: nil).instantiateInitialViewController() as? UITabBarController
        vc?.selectedIndex = 2
        rootviewcontroller.rootViewController = vc
        rootviewcontroller.makeKeyAndVisible()
    }
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if SettingsManager.manager.getUserToken() != "",SettingsManager.manager.getCurrentStatus() == "Active"{
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            
            let vc = UIStoryboard(name: "Tab", bundle: nil).instantiateInitialViewController() as? UITabBarController
            rootviewcontroller.rootViewController = vc
            rootviewcontroller.makeKeyAndVisible()
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) {
            (granted , error) in
            if granted {
                print("user gave primission")
            }
        }
        OTPInputView.appearance().semanticContentAttribute = .forceLeftToRight
//        GoSellSDK.secretKey = SecretKey(sandbox:"sk_test_c6jIvnbZpLXUkzuYx3NhHR04",production:"sk_live_yK1QVjrfcgCqvxukHOlTWDw4")
        //        GoSellSDK.mode = .sandbox
        MOLHLanguage.setDefaultLanguage("ar")
        MOLH.shared.activate(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = true
        NotificationHandler.register(appDelegate: self, application: application)
        
        
        MFSettings.shared.configure(token: "HVVoZRB9ranDChJjfiuvB0m-Q7evCCUfMucV0z1zIom9PFYTHx_ePrbfWOP1_tDbd7aRcN6e2h0slxrUEjsvTKhMyFXMbo3TAHChbKVQuKtHhVpT9yYJQBKf0o_M1QqdZAAwjpHidWBLagYyuR_U-6RqgocRWNfJEPgB-Fb8wAcFO6lyuU0OSzV0zBdlFC0G2GEmODdt8C21gZUvdje2Wf_j4xiy5tWsnFOGJf_mfkboa19p5-wH_JYHvEurljtJDzht5qkEPI-eX8nzD8p-CyfJot0ga-f5NExSmuCXxk6fih9DLvLil-rPxAKPdNBhbTG513DzvwPiWd5F6pcLHmViWX-LCHSUjM4f5j4DFYvVgTneDESc-hijyHU1cCMpgyLNOoC_U_B4fgyDJ_9r_ruYTfIy2Tj88wDkAO7KKoMfUfdjkwKmCJmRDuBs-aYrAaqfdP3L8ztdLJYdNNALjbFY9Mbh4DIbhXGji3W5Gg6AYVIXrWzfGQhaLChUZGtDF6urkesIdQsBukeG5unvYie2OwzsbvzGYKp_vheGzXiDmfPpEOSSny07ojAIxRScrVOZd1qZ7oOXC_1oU8bYcRqr-uq9Yx8guRjj0G_DnZarHUJcyRyAdvGblMoBEeIDDlxD0OMffnwusTr4tbYoA0dNpdp8SEbN0rGn3nNoHHMO902XTLWQpZb80eO5rcxaCGIWzA", baseURL: MFBaseURL(rawValue: "https://api.myfatoorah.com")!)
        
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: UIColor.PrimaryColor!, navigationTitle: "Payment".localized, cancelButtonTitle: "Cancel".localized)
        MFSettings.shared.setTheme(theme: them)
        
        return true
    }
}

