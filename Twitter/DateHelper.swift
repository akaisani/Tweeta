//
//  DateHelper.swift
//  Twitter
//
//  Created by Abid Amirali on 1/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import Foundation

struct DateHelper {
    static func timeSincePost(for postDateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMM dd HH:mm:ss Z yyyy" //Your date format
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        guard let date = dateFormatter.date(from:postDateString) else {return postDateString}
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        guard let postDate = calendar.date(from:components) else {return postDateString}
        
        
        let currentDate = Date()
        
        let differenceYears = currentDate.years(from: postDate)
        guard differenceYears < 1 else {return "\(differenceYears)y"}
        
        let differenceMonths = currentDate.months(from: postDate)
        guard differenceMonths < 1 else {return "\(differenceMonths)M"}
        
        let differenceDays = currentDate.days(from: postDate)
        guard differenceDays < 1 else {return "\(differenceDays)d"}
        
        let differenceHours = currentDate.hours(from: postDate)
        guard differenceHours < 1 else {return "\(differenceHours)h"}
        
        let differenceMinutes = currentDate.minutes(from: postDate)
        guard differenceMinutes < 1 else {return "\(differenceMinutes)m"}
        
        let differenceSeconds = currentDate.seconds(from: postDate)
        return "\(differenceSeconds)s"
    }
    
}
