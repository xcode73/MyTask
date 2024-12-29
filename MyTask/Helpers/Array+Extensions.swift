//
//  Array+Extensions.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 28.12.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
