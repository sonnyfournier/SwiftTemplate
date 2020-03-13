//
//  UIView.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 13/03/2020.
//

import UIKit

extension UIView {
    
    /// Add multiples views as subviews
    /// - Parameter subviews: views to add as subviews
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
