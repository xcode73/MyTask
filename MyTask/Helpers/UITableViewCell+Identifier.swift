//
//  UITableViewCell+Identifier.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

/// This extension provides a computed static property reuseIdentifier that returns the string representation of the class name.
extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
