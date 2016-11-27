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
        dateFormatter.dateFormat = "MMMM d, yyyy h:m a"
        return dateFormatter.string(from: date)
    }
    
}
