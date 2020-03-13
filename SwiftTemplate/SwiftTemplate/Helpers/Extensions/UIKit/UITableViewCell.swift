//
//  UITableViewCell.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 13/03/2020.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
