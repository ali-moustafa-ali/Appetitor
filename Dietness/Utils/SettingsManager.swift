//
//  SettingsManager.swift
//  Gaxa
//
//  Created by karim metawea on 6/4/20.
//  Copyright © 2020 Rami Suliman. All rights reserved.
//

import Foundation
import CoreLocation

class SettingsManager {
    
    static var manager:SettingsManager = SettingsManager()
    
    enum Settings : String {
        case  FirstTime, IsLoggedIn, UserToken, UserId, FirstName, LastName, Email,
        PhoneNumber, Password, ProfilePic, SocialPic, Active, Confirmed, DeviceToken,
        City, Country , verified ,UserLocation,selectedPlan,countryCode , currentSubiscribtion , sellectedPackage,currentStatus
    }
    
    var userDefault: UserDefaults
    
    init() {
        userDefault = UserDefaults.standard
    }
    
    func setLastName(value:String)  {
        let _ =  save(object: value, setting: Settings.LastName)
    }
    
    func setVerification(value:Bool?){
        if let value = value{
            let _ =  save(object: value, setting: Settings.verified)
        }else{
            userDefault.removeObject(forKey: Settings.verified.rawValue)
        }

    }
    
        func setCountryCode(value : String?) {
            if let value = value{
                let _ =  save(object: value, setting: Settings.countryCode)
            }else{
                userDefault.removeObject(forKey: Settings.countryCode.rawValue)
            }
        }
    
    func setCurrentStatus(value:String?){
        if let value = value{
            let _ =  save(object: value, setting: Settings.currentStatus)
        }else{
            userDefault.removeObject(forKey: Settings.currentStatus.rawValue)
        }
    }

    
    
    
    
    
    
    func setDeviceToken(value:String)  {
        let _ =  save(object: value, setting: Settings.DeviceToken)
    }
    
    func setSocialPic(value : String?) {
        if let value = value{
            let _ =  save(object: value, setting: Settings.SocialPic)
        }else{
            userDefault.removeObject(forKey: Settings.SocialPic.rawValue)
        }
    }
    
//    func setActive(value : Int) {
//        let _ =  save(object: value, setting: Settings.Active)
//    }
    
//    func setConfirmed(value : Int) {
//        let _ =  save(object: value, setting: Settings.Confirmed)
//    }
    
//    func setFirstTime(value : Bool) {
//        let _ =  save(object: value, setting: Settings.FirstTime)
//    }
    
    func setLoggedIn(value:Bool) {
        if (!value) {
            resetAccount();
        }
        let _ = save(object: value, setting: Settings.IsLoggedIn)
    }
    
    
    
    func updateUser(user : User?) {
        setUserId(value: user?.id ?? 0)
        setFirstName(value: user?.name ?? "")
       setEmail(value: user?.email ?? "")
        if let str = user?.mobile {
            setPhoneNumber(value: str)
        }
        setCountryCode(value: user?.country_code ?? "")
        let nameComponents = user?.name?.components(separatedBy: " ")
        setFirstName(value: nameComponents?.first ?? "")
        setLastName(value: nameComponents?.last ?? "")
    }
    
    func getUser () -> User {

         let user =  User(id: getUserId(), name: getFirstName(), email: getEmail(), country_code: getCountryCode(), mobile: getPhoneNumber(), email_verified_at: nil, mobile_verified_at: nil, birth: nil, status: nil, fcmToken: nil, current_subscription: getCurrentSubiscription())
//        user.id = getUserId()
//        user.name = getFirstName()
//        user.email = getEmail()
//        user.profilePic = getProfilePic()
//        user.phone = getPhoneNumber()
//        user.lname = getLastName()
//        user.city = getCity()
//        user.country = getCountry()
        return user;
    }
    
    func resetAccount() {
        setIsloggedIn(value: false)
        setUserToken(value: "")
        setEmail(value: "")
        setPassword(value: "")
        setPhoneNumber(value: "")
        setFirstName(value: "")
        setUserId(value: 0)
        setLastName(value: "")
        setVerification(value: nil)
        setProfilePic(value: "")
        setSubiscribtion(value: nil)
        setCountryCode(value: nil)
        setCurrentStatus(value: nil)

//        setCity(value: nil)
//        setArea(value: nil)
    }
    
    func setIsloggedIn (value:Bool){
        let _ = save(object: value, setting: Settings.IsLoggedIn)
    }
    
    
    func setUserToken(value :String) {
        let _ =  save(object: value, setting: Settings.UserToken);
    }
    
    func setUserId( value : Int) {
        let _ = save(object: value, setting: Settings.UserId)
    }
    
    func setFirstName( value : String) {
        let _ = save(object: value, setting: Settings.FirstName)
    }
    
    func setEmail( value:String) {
        let _ = save(object: value, setting: Settings.Email)
    }
    
    func setPassword( value:String) {
        let _ = save(object: value, setting: Settings.Password)
    }
    
    func setPhoneNumber( value:String) {
        let _ = save(object: value, setting: Settings.PhoneNumber)
    }
    
    
    func setProfilePic(value : String) {
        let _ =  save(object: value, setting: Settings.ProfilePic)
    }
    
    func setCity(value: City?) {
        if let city = value{
            save(customObject: city, inKey: Settings.City.rawValue)
        }else{
            userDefault.removeObject(forKey: Settings.City.rawValue)
        }
    }
    func setSelectedPlan(value:Plan?){
        if let plan = value{
            save(customObject: plan, inKey: Settings.selectedPlan.rawValue)
        }else{
            userDefault.removeObject(forKey: Settings.selectedPlan.rawValue)
        }
    }
    
    func setSelectedPackage(value:Package?){
        if let plan = value{
                   save(customObject: plan, inKey: Settings.sellectedPackage.rawValue)
               }else{
                   userDefault.removeObject(forKey: Settings.sellectedPackage.rawValue)
               }
    }
    
    func setSubiscribtion(value:CurrentSubscription?){
        if let plan = value{
            save(customObject: plan, inKey: Settings.currentSubiscribtion.rawValue)
        }else{
            userDefault.removeObject(forKey: Settings.currentSubiscribtion.rawValue)
        }
    }
    
   
    
    
    
  
    
   
    
    func getCountryCode()->String?{
         if let object = userDefault.object(forKey: Settings.countryCode.rawValue) {
            return object as? String
        }
        return nil
    }
    
    func getCurrentStatus()->String?{
        if let object = userDefault.object(forKey: Settings.currentStatus.rawValue) {
           return object as? String
       }
       return nil
   }
    
    func getCity() -> City? {
        if let city = retrieve(object: City.self, fromKey: Settings.City.rawValue) {
            return city
        }
        return nil
    }
    func getSelectedPlan()->Plan?{
        if let plan = retrieve(object: Plan.self, fromKey: Settings.selectedPlan.rawValue){
            return plan
        }
        return nil
    }
    
    func getSelectedPackage()->Package?{
        if let plan = retrieve(object: Package.self, fromKey: Settings.sellectedPackage.rawValue){
                   return plan
               }
               return nil
    }
    
    func getCurrentSubiscription()->CurrentSubscription?{
        if let subscribtion = retrieve(object: CurrentSubscription.self, fromKey: Settings.currentSubiscribtion.rawValue){
            return subscribtion
        }
        return nil
    }

    func getCountry() -> String {
        if let object = userDefault.object(forKey: Settings.Country.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func isFirstTime() ->Bool {
        if let object = userDefault.object(forKey: Settings.FirstTime.rawValue) {
            return object as! Bool
        }
        return true
    }
    
    func isLoggedIn() -> Bool {
        if let object = userDefault.object(forKey: Settings.IsLoggedIn.rawValue) {
            return object as! Bool
        }
        return false
    }
    
    func isVerified() -> Bool?{
        if let object = userDefault.object(forKey: Settings.verified.rawValue) {
            return object as? Bool
               }
               return nil
    }
    
    
    func getUserToken()  -> String {
        if let object = userDefault.object(forKey: Settings.UserToken.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getLastName()  -> String {
        if let object = userDefault.object(forKey: Settings.LastName.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getUserId() -> Int  {
        if let object = userDefault.object(forKey: Settings.UserId.rawValue) {
            return object as! Int
        }
        return 0
    }
    
    func getFirstName() -> String {
        if let object = userDefault.object(forKey: Settings.FirstName.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getEmail() -> String{
        if let object = userDefault.object(forKey: Settings.Email.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getPassword() -> String {
        if let object = userDefault.object(forKey: Settings.Password.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getPhoneNumber() -> String{
        if let object = userDefault.object(forKey: Settings.PhoneNumber.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getProfilePic() -> String {
        if let object = userDefault.object(forKey: Settings.ProfilePic.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getSocialPic() -> String {
        if let object = userDefault.object(forKey: Settings.SocialPic.rawValue) {
            return object as! String
        }
        return ""
    }
    
    func getActive() -> Int {
        if let object = userDefault.object(forKey: Settings.Active.rawValue) {
            return object as! Int
        }
        return 0
    }
    func getConfirmed() -> Int {
        if let object = userDefault.object(forKey: Settings.Confirmed.rawValue) {
            return object as! Int
        }
        return 0
    }
    func getDeviceToken() -> String{
        if let object = userDefault.object(forKey: Settings.DeviceToken.rawValue) {
            return object as! String
        }
        return ""
    }
    
    
    
    private func save(object: Any, setting: Settings) -> Bool {
        if (object is Int) {
            userDefault.set(object as! Int, forKey: setting.rawValue)
        } else if (object is Bool) {
            userDefault.set(object as! Bool, forKey: setting.rawValue)
        } else if (object is String) {
            userDefault.set(object as! String, forKey: setting.rawValue)
        } else {
            userDefault.set(object, forKey: setting.rawValue)
        }
        
        return userDefault.synchronize()
    }
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(object) {
              userDefault.set(encoded, forKey: key)
          }
      }
    func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
         if let data = userDefault.data(forKey: key) {
             let decoder = JSONDecoder()
             if let object = try? decoder.decode(type, from: data) {
                 return object
             }else {
                 print("Couldnt decode object")
                 return nil
             }
         }else {
             print("Couldnt find key")
             return nil
         }
     }
    
    
}



