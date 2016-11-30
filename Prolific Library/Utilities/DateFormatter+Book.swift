//
//  NSDateFormatter+Book.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 27/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    public static func format(lastCheckedOutDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        return dateFormatter.string(from: date)
    }
    
    public static var jsonDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
}
