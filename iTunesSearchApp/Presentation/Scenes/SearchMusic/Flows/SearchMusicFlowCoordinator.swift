//
//  SearchMusicFlowCoordinator.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class SearchMusicFlowCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    var dependencyProvider: SearchMusicFlowDependencyProviding
    
    init(navigationController: UINavigationController, dependencyProvider: SearchMusicFlowDependencyProviding) {
        self.navigationController = navigationController
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let searchResultsViewModel = dependencyProvider.makeSearchResultsListViewModel()
        let searchResultsViewController = dependencyProvider.makeSearchResultsViewController(with: searchResultsViewModel)
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
}

