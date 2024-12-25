//
//  GeometricParams.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import Foundation

struct GeometricParams {
    let topInset: CGFloat
    let bottomInset: CGFloat
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    
    init(
        topInset: CGFloat,
        bottomInset: CGFloat,
        leftInset: CGFloat,
        rightInset: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
    }
}
