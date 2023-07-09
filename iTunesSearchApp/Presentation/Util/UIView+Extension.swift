//
//  UIView+Extension.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}
