//
//  String+Localizable.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 7/7/2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
