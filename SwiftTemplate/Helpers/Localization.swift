//
//  Localization.swift
//  SwiftTemplate
//
//  Created by Sonny on 07/09/2021.
//

import Foundation

func localizedString(for key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}
