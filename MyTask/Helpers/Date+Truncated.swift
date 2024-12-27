//
//  Date+Truncated.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 26.12.2024.
//

import Foundation

extension Date {
    var truncated: Date? {
        get {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: self)
            dateComponents.timeZone = calendar.timeZone
            return calendar.date(from: dateComponents)
        }
    }
    
    var plusOneHour: Date? {
        let calendar = Calendar.current
        let components = DateComponents(hour: 1)
        return calendar.date(byAdding: components, to: self)
    }
    
    var minusOneHour: Date? {
        let calendar = Calendar.current
        let components = DateComponents(hour: -1)
        return calendar.date(byAdding: components, to: self)
    }
}
