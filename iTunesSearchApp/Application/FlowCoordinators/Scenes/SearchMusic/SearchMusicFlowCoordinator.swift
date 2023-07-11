//
//  SearchMusicFlowCoordinator.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation
import UIKit
import SwiftUI

protocol Navigatable {
}

protocol Coordinator: AnyObject {
    func start()
    func navigate(to path: Navigatable)
}

enum MusicSearchNavigationPath: Navigatable {
    case detailView(Song)
}

final class SearchMusicFlowCoordinator: Coordinator {
    
    private var searchResultsViewController: SearchResultsListViewController?
    
    weak var navigationController: UINavigationController?
    var dependencyProvider: SearchMusicFlowDependencyProviding
    
    init(navigationController: UINavigationController, dependencyProvider: SearchMusicFlowDependencyProviding) {
        self.navigationController = navigationController
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let searchResultsViewModel = dependencyProvider.makeSearchResultsListViewModel()
        searchResultsViewController = dependencyProvider.makeSearchResultsViewController(with: searchResultsViewModel)
        if let searchResultsVC = searchResultsViewController {
            searchResultsVC.coordinator = self
            navigationController?.pushViewController(searchResultsVC, animated: true)
        }
        
    }
    
    func navigate(to path: Navigatable) {
        if let path = path as? MusicSearchNavigationPath {
            switch path {
            case .detailView(let song):
                searchResultsViewController?.present(dependencyProvider.makeSongDetailHostingController(with: song), animated: true)
            }
        }
    }
    
    
}

