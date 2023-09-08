//
//  DateUtils.swift
//  kora
//
//  Created by Abanoub Osama on 3/3/18.
//  Copyright © 2018 Abanoub Osama. All rights reserved.
//

import Foundation

class DateUtils {
    
    public static let DAY_INTERVAL = TimeInterval(24 * 60 * 60)
    
    public static let TRYPS_DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    public static let SERVER_DATE_FORMAT = "yyyy-MM-dd"
    public static let SERVER_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"
    public static let SERVER_TIME_SHORT_FORMAT = "HH:mm"
    
    public static let APP_DATE_FORMAT = "d MMM, yyyy"
    public static let APP_DATE_SHORT_FORMAT = "dd.MM"
    public static let APP_TIME_FORMAT = "hh:mm a"
    public static let APP_DATE_TIME_FORMAT = "hh:mm a E, MMM.d yyyy"
    public static let APP_DATE_TIME_SHORT_FORMAT = "d MMM, hh:mm a"
    
    public static func getDate(dateString: String, dateFormat: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: dateString) ?? Date()
    }
    
    public static func getDateString(date: Date, dateFormat: String , langauage:String = "en") -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: langauage)
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: date)
    }
    
    public static func getDateString(date:Date,formatter:DateFormatter,dateFormat:String) -> String{
//        formatter.locale = Locale(identifier: Constants.getAppLanguage())
        
        formatter.dateFormat = dateFormat
               
        return formatter.string(from: date)
    }
    
    public static func getRelativeDay(date:Date,formatter:DateFormatter , dateFormat:String) -> String{
//           formatter.locale = Locale(identifier: Constants.getAppLanguage())
        if Calendar.current.isDateInToday(date) {
             formatter.dateStyle = .medium
             formatter.doesRelativeDateFormatting = true
                return formatter.string(from: date)
        }
        else if Calendar.current.isDateInTomorrow(date) {
            formatter.dateStyle = .medium
            formatter.doesRelativeDateFormatting = true
               return formatter.string(from: date)
        }else{
            formatter.dateFormat = dateFormat
            return formatter.string(from: date)
        }
       }
    
    
    
    public static func convertDateFormat(dateString: String, sourceFormat: String, destinationFormat: String , locale:String = "en") -> String {
        let sourceFormatter = DateFormatter()
        sourceFormatter.locale = Locale(identifier: locale)
        sourceFormatter.dateFormat = sourceFormat
        
        let destinationFormatter = DateFormatter()
        destinationFormatter.locale = Locale(identifier: locale)
        destinationFormatter.dateFormat = destinationFormat
        
        if let date = sourceFormatter.date(from: dateString) {
            return destinationFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    public static func getServerDateString(appDateString: String) -> String {
        
        return convertDateFormat(dateString: appDateString, sourceFormat: APP_DATE_FORMAT, destinationFormat: SERVER_DATE_FORMAT)
    }
    
    public static func getServerDate(dateString: String) -> Date {
        
        return getDate(dateString: dateString, dateFormat: SERVER_DATE_FORMAT)
    }
    
    public static func getServerDateTime(dateString: String) -> Date {
        
        return getDate(dateString: dateString, dateFormat: SERVER_DATE_TIME_FORMAT)
    }
    
    public static func getAppDate(dateString: String) -> Date {
        
        return getDate(dateString: dateString, dateFormat: APP_DATE_FORMAT)
    }
    
    public static func getServerDateString(timeInMillis: TimeInterval) -> String {
        
        let date = Date(timeIntervalSince1970: timeInMillis)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = SERVER_DATE_FORMAT
        
        return formatter.string(from: date)
    }
    
    public static func getServerDateTimeString(timeInMillis: TimeInterval) -> String {
        
        let date = Date(timeIntervalSince1970: timeInMillis)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = SERVER_DATE_TIME_FORMAT
        
        return formatter.string(from: date)
    }
    
    public static func getAppDateString(timeInMillis: TimeInterval) -> String {
        
        let date = Date(timeIntervalSince1970: timeInMillis)
        
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: Constants.getAppLanguage())
        formatter.dateFormat = APP_DATE_FORMAT
        
        return formatter.string(from: date)
    }
    
    public static func getAppDateTimeString(timeInMillis: TimeInterval) -> String {
        
        let date = Date(timeIntervalSince1970: timeInMillis)
        
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: Constants.getAppLanguage())
        formatter.dateFormat = APP_DATE_TIME_FORMAT
        
        return formatter.string(from: date)
    }
    
    public static func getAppDateStringFromServerDateTime(serverDateTime: String) -> String {
        
        return convertDateFormat(dateString: serverDateTime, sourceFormat: SERVER_DATE_TIME_FORMAT, destinationFormat: APP_DATE_FORMAT);
    }
    
    public static func getAppDateTimeString(serverDate: String) -> String {
        
        return convertDateFormat(dateString: serverDate, sourceFormat: SERVER_DATE_TIME_FORMAT, destinationFormat: APP_DATE_TIME_FORMAT);
    }
    
    public static func getAppDateString(serverDate: String) -> String {
        
        return convertDateFormat(dateString: serverDate, sourceFormat: SERVER_DATE_FORMAT, destinationFormat: APP_DATE_FORMAT);
    }
    
    public static func getAppTimeString(serverDate: String) -> String {
        
        return convertDateFormat(dateString: serverDate, sourceFormat: SERVER_DATE_FORMAT, destinationFormat: APP_TIME_FORMAT);
    }
    
    public static func getAppTimeString(forFrom from: Date, toDates to: Date) -> String {
        
        let formatterFrom = DateFormatter()
//        formatterFrom.locale = Locale(identifier: Constants.getAppLanguage())
        formatterFrom.dateFormat = "hh:mm a"
        
        let formatterTo = DateFormatter()
//        formatterTo.locale = Locale(identifier: Constants.getAppLanguage())
        formatterTo.dateFormat = "hh:mm a"
        
        return "\(formatterFrom.string(from: from)) - \(formatterTo.string(from: to))"
    }
    
    public static func getAppTimeWithoutDayString(forFrom from: Date, toDates to: Date) -> String {
        
        let formatterFrom = DateFormatter()
//        formatterFrom.locale = Locale(identifier: Constants.getAppLanguage())
        formatterFrom.dateFormat = "hh:mm a"
        
        let formatterTo = DateFormatter()
//        formatterTo.locale = Locale(identifier: Constants.getAppLanguage())
        formatterTo.dateFormat = "hh:mm a"
        
        return "\(formatterFrom.string(from: from)) - \(formatterTo.string(from: to))"
    }
    
    public static func getAppDateString(forFrom from: Date, toDates to: Date) -> String {
        
        let formatterFrom = DateFormatter()
//        formatterFrom.locale = Locale(identifier: Constants.getAppLanguage())
        formatterFrom.dateFormat = APP_DATE_FORMAT
        
        let formatterTo = DateFormatter()
//        formatterTo.locale = Locale(identifier: Constants.getAppLanguage())
        formatterTo.dateFormat = APP_DATE_FORMAT
        
        return "\(formatterFrom.string(from: from)) - \(formatterTo.string(from: to))"
    }
    
    public static func getTimeAgoString(date: Date) -> String {
        
        let interval = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from: date, to: Date())
        
        if let day = interval.day, day > 6 {
            return DateUtils.getAppDateTimeString(timeInMillis: date.timeIntervalSince1970)
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day) \(NSLocalizedString("day_ago", comment: ""))" :
            "\(day) \(NSLocalizedString("days_ago", comment: ""))"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour) \(NSLocalizedString("hour_ago", comment: ""))" :
            "\(hour) \(NSLocalizedString("hours_ago", comment: ""))"
        } else if let min = interval.minute, min > 0 {
            return min == 1 ? "\(min) \(NSLocalizedString("minute_ago", comment: ""))" :
            "\(min) \(NSLocalizedString("minutes_ago", comment: ""))"
        } else {
            return NSLocalizedString("just_now", comment: "")
        }
    }
}

