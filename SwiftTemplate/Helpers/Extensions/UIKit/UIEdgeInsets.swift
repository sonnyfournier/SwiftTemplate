//
//  UIEdgeInsets.swift
//  SwiftTemplate
//
//  Created by Sonny on 07/09/2021.
//

import UIKit

extension UIEdgeInsets {

    /// Apply same inset to all directions
    /// - Parameter all: The inset to apply
    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

    /// Apply an inset for vertical and horizontal directions
    /// - Parameters:
    ///   - vertical: The vertical inset to apply (top and bottom)
    ///   - horizontal: The horizontal inset to apply (left and right)
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

}
