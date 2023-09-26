//
//  NotificationHandler.swift
//  balto
//
//  Created by Abanoub Osama on 5/19/18.
//  Copyright © 2018 Abanoub Osama. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

public class NotificationHandler {
    
    public static var token: String!
    
    public enum Kind: String {
        case general
    }
    
    static func register(appDelegate: AppDelegate, application: UIApplication) {
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = appDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = appDelegate
    }
    
    @discardableResult
    public static func handle(notification: [AnyHashable: Any]) -> Bool {
        
        let userInfo = notification
        
        var data = [String: Any]()
        var payload = [String: Any]()
        if let dataString = userInfo["data"] as? String, let d = dataString.data(using: String.Encoding.utf8) {
            do {
                data = try JSONSerialization.jsonObject(with: d, options: []) as! [String: Any]
                if let p = data["payload"] as? [String: Any] {
                    
                    payload = p
                } else {
                    return false
                }
            } catch {
                print("\n\n\n\nuserInfo:\(error)\n\n\n\n")
                return false
            }
        } else {
            return false
        }
        
        let kindName = payload["kind"] as? String ?? ""
        
        let kind = Kind(rawValue: kindName)
        
        var vc: UIViewController!
        let title = NSLocalizedString("\(kind?.rawValue ?? "")Title", comment: "")
        let body = NSLocalizedString("\(kind?.rawValue ?? "")Body", comment: "")
        
        if let kind = kind {
            
            switch kind {
            case .general:
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                break
            }
        }
        
        if userInfo["showNotification"] as? Bool ?? true {
            
            var userInfo = userInfo
            userInfo["showNotification"] = true
            NotificationHandler.showNotification(title: title, body: body, userInfo: userInfo)
        } else {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if let vc = vc, let window = appDelegate.window {
                
                if let root = window.rootViewController {
                    var currentViewController = root
                    
                    if let nav = currentViewController as? UINavigationController {
                        
                        nav.show(vc, sender: nil)
                    } else {
                        
                        while let presentedViewController = currentViewController.presentedViewController {
                            currentViewController = presentedViewController
                        }
                        
                        currentViewController.present(vc, animated: true, completion: nil)
                    }
                } else {
                    
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }
            } else {
                
                return false
            }
        }
        
        return true
    }
    
    private static func showNotification(title: String, body: String, userInfo: [AnyHashable: Any]) {
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            let requestIdentifier = Bundle.main.bundleIdentifier!
            
            content.badge = 1
            content.title = title
            content.body = body
            
            content.sound = UNNotificationSound.default
            
            var notification = userInfo
            notification["showNotification"] = false
            
            content.userInfo = notification
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                
                if let error = error {
                    
                    print(error.localizedDescription)
                } else {
                    
                    print("Notification Register Success")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken)
        NotificationHandler.token = fcmToken
//        SettingsManager().setDeviceToken(value: fcmToken)
        if SettingsManager.manager.getUserToken() != "" {
            Connect.default.request(RegisterationConnector.updateDeviceToken(token: fcmToken ?? "")).dictionary().observe { (result) in
                switch result {
                
                case .success(_):
                    print("success")
                case .failure(_):
                    print("fail")
                }
            }
        }
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        let value = userInfo.first(where:  { $0.key as! String == "data"})?.value
        let action = userInfo.first(where:  { $0.key as! String == "action"})?.value
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Appetitor"
        content.body = "\(value ?? "")"
        UserDefaults.standard.setValue("\(action ?? "")", forKey: "NValue")
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("ERRor")
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func showLocalNotification(title: String, body: String) {

        //creating the notification content
        let content = UNMutableNotificationContent()

        //adding title, subtitle, body and badge
        content.title = title
        //content.subtitle = "local notification"
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default

        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)

        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])

        
        let userInfo = notification.request.content.userInfo
//        if let vc =  UIApplication.shared.topMostViewController() as? TrackOrderVC{
//            vc.requestOrderStatus(completion: nil)
//        }
        
//        if let dataString = userInfo["data"] as? NSDictionary ,let pickup = dataString["pickup"] as? String , let orderReadyTime = dataString["order_ready_time"] as? String{
////            check order is takeaway
//            vc?.view.makeToast("your order will be ready in \(orderReadyTime) minute")
//        }else{
//            vc?.view.makeToast((userInfo["data"] as? String) ?? "your order is not ready" )
//        }
//        // Change this to your preferred presentation option
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let body = response.notification.request.content.body
        let nValue = UserDefaults.standard.value(forKey: "NValue")
        let s =  "\(nValue ?? "")"
        print("body = \(body)")
        if (s == "RENEWAL") || (s == "renewal") {
        if SettingsManager.manager.getUserToken() != "",SettingsManager.manager.getCurrentStatus() == "Active"{
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            
            let vc = UIStoryboard(name: "Tab", bundle: nil).instantiateInitialViewController() as? UITabBarController
            vc?.selectedIndex = 0
        rootviewcontroller.rootViewController = vc
        rootviewcontroller.makeKeyAndVisible()
        }
        }else {
            if SettingsManager.manager.getUserToken() != "",SettingsManager.manager.getCurrentStatus() == "Active"{
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                
                let vc = UIStoryboard(name: "Tab", bundle: nil).instantiateInitialViewController() as? UITabBarController
                vc?.selectedIndex = 1
            rootviewcontroller.rootViewController = vc
            rootviewcontroller.makeKeyAndVisible()
        }
        }
        completionHandler()
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     Messaging.messaging().apnsToken = deviceToken
//     let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//     let token = tokenParts.joined()
    }

}


extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}


extension UIApplication {
  func topMostViewController() -> UIViewController? {
    return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
  }
}
