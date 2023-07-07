//
//  FontStyles.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 7/7/2023.
//

import Foundation
import UIKit

enum AppFontStyle {
    case title
    case subtitle
    case body
}

class FontUtility {
    static func font(for style: AppFontStyle, size: CGFloat? = nil) -> UIFont {
        switch style {
        case .title:
            return UIFont.systemFont(ofSize: size ?? 16, weight: .bold)
        case .subtitle:
            return UIFont.systemFont(ofSize: size ?? 14, weight: .medium)
        case .body:
            return UIFont.systemFont(ofSize: size ?? 12, weight: .regular)
        }
    }
}
