//
//  SearchResultsListViewController.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import UIKit
import Combine

class SearchResultsListViewController: UIViewController {
    
    // MARK: UI Elements
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "searchbar_placeholder".localized
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        tableView.estimatedRowHeight = SearchResultsTableViewCell.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let viewModel = SearchResultsListViewModel()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, Song> = {
        return UITableViewDiffableDataSource<Int, Song>(tableView: tableView) { tableView, indexPath, song in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath) as? SearchResultsTableViewCell else { return UITableViewCell() }
            cell.configure(with: song)
            return cell
        }
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        tableView.delegate = self
    }
    
    private func setupUI() {
        title = "search_title".localized
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$songs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] songs in
                self?.applySnapshot(with: songs)
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(with songs: [Song]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Song>()
        snapshot.appendSections([0])
        snapshot.appendItems(songs)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: UITableViewDelegate methods

extension SearchResultsListViewController: UITableViewDelegate {
    
}
