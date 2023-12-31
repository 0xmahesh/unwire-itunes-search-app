//
//  SearchMusicFlowDependencyProviding.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit
import SwiftUI

protocol SearchMusicFlowDependencyProviding {
    func makeSearchResultsListViewModel() -> SearchResultsListViewModel
    func makeSearchResultsViewController(with viewModel: SearchResultsListViewModel) -> SearchResultsListViewController
    func makeSearchMusicFlowCoordinator(navigationController: UINavigationController) -> SearchMusicFlowCoordinator
    func makeSongDetailHostingController(with song: Song) -> UIViewController 
}
