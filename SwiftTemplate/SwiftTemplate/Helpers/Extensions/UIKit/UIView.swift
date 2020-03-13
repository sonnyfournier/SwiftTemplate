//
//  UIView.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 13/03/2020.
//

import UIKit

extension UIView {

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
