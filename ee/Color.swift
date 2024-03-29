//
//  Color.swift
//  ee
//
//  Created by Admin on 11/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Cocoa
extension NSColor {
    convenience init(_ rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
