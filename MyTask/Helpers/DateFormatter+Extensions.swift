//
//  DateFormatter+Extensions.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import Foundation

extension DateFormatter {
    static let shortTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        
        return df
    }()
}
