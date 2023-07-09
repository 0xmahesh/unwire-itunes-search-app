//
//  UIViewController+Alert.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { _ in
            buttonAction?()
        }
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
