//
//  SearchResultsListViewController.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import UIKit
import Combine

class SearchResultsListViewController: BaseViewController<SearchResultsListViewModel> {

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "searchbar_placeholder".localized
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        tableView.estimatedRowHeight = SearchResultsTableViewCell.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "empty_search_results_message".localized
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = FontUtility.font(for: .subtitle)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, Song> = {
        return UITableViewDiffableDataSource<Int, Song>(tableView: tableView) { [weak self] tableView, indexPath, song in
            guard let strSelf = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath) as? SearchResultsTableViewCell else { return UITableViewCell() }
            cell.configure(with: SearchResultsListItemViewModel(with: song, fetchImageUseCase: strSelf.viewModel.fetchImagesUseCase))
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
        view.addSubViews([searchBar, tableView, noResultsLabel])
        setupConstraints()
        searchBar.searchTextField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBindings() {
        bindSearchTextField()
        bindViewStates()
    }
    
    private func bindViewStates() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let strSelf = self else { return }
                switch state {
                case .isLoading(let isLoading):
                    print("isLoading: \(isLoading)") //TODO: add activity indicator
                case .updateDataSource(let songs):
                    strSelf.showNoResultsBanner(songs.isEmpty && !strSelf.viewModel.searchTerm.isEmpty)
                    strSelf.applySnapshot(with: songs)
                case .error(let error):
                    strSelf.showAlert(title: error.title, message: error.description)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSearchTextField()  {
        let searchPublisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
            .debounce(for: .milliseconds(viewModel.searchTextFieldDebounceThreshold), scheduler: DispatchQueue.main)
            .map { ($0.object as? UISearchTextField)?.text ?? "" }
            .removeDuplicates()
        
        searchPublisher
            .sink { [weak self] query in
                Task {
                    await self?.viewModel.search(with: query)
                }
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(with songs: [Song]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Song>()
        snapshot.appendSections([0])
        snapshot.appendItems(songs)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func showNoResultsBanner(_ show: Bool) {
        noResultsLabel.isHidden = !show
    }
    
}

// MARK: UITableViewDelegate methods

extension SearchResultsListViewController: UITableViewDelegate {
    
}

private extension UIView {
    func addSubViews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension SearchResultsListViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        showNoResultsBanner(true)
        viewModel.clearResults()
        return true
    }
}
