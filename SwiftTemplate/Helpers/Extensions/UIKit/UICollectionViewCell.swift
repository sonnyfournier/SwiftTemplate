//
//  UICollectionViewCell.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 28/03/2020.
//

import UIKit

extension UICollectionViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
