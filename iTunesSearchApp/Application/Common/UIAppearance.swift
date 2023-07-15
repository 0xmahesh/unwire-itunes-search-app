//
//  UIAppearance.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 15/7/2023.
//

import Foundation
import UIKit

class UIAppearance {
    static func setupGlobalNavigationBarAppearance() {
        lazy var navigationBarAppearance = UINavigationBar.appearance()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.black]
        
        
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.standardAppearance = appearance
        navigationBarAppearance.scrollEdgeAppearance = appearance
        navigationBarAppearance.prefersLargeTitles = true
        navigationBarAppearance.clipsToBounds = true
    }
}
