//
//  SearchResultsTableViewCell.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import UIKit

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: SearchResultsTableViewCell.self)
    static let estimatedRowHeight: CGFloat = 85

    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtility.font(for: .title)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtility.font(for: .subtitle)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtility.font(for: .body)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private var viewModel: SearchResultsListItemViewModel?
    
    // Parent stack view
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artworkImageView, verticalStackView])
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4.0
        return stackView
    }()
    
    @MainActor
    func configure(with vm: SearchResultsListItemViewModel) {
        self.viewModel = vm
        titleLabel.text = vm.title
        artistLabel.text = vm.subtitle
        descriptionLabel.text = vm.description
        
        Task {
            artworkImageView.image = await viewModel?.fetchAlbumArtwork()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        viewModel?.fetchImageTask?.cancel()
        artworkImageView.image = nil
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            artworkImageView.widthAnchor.constraint(equalToConstant: 60),
            artworkImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}



