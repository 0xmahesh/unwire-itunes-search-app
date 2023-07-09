//
//  AppFlowCoordinator.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

final class AppFlowCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let dependencyContainer: AppDIContainer
    
    init(navigationController: UINavigationController, dependencyContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        let searchMusicSceneDI = dependencyContainer.makeSearchMusicSceneDIContainer()
        let searchMusicFlowCoordinator = searchMusicSceneDI.makeSearchMusicFlowCoordinator(navigationController: navigationController)
        searchMusicFlowCoordinator.start()
    }
    
    
}

