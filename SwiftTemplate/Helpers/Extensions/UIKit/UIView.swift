//
//  UIView.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 13/03/2020.
//

import UIKit

extension UIView {

    /// Add optional view as subview if not nil
    /// - Parameter subview: view to add as subview
    func addSubviews(_ subview: UIView?) {
        if let subview = subview { addSubview(subview) }
    }

}
