//
//  UIStackView.swift
//  SwiftTemplate
//
//  Created by Sonny on 07/09/2021.
//

import UIKit

extension UIStackView {

    /// Remove all arranged subviews in stack view
    func removeAllArrangedSubview() {
        for subview in arrangedSubviews { subview.removeFromSuperview() }
    }

}
