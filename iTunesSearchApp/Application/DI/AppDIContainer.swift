//
//  AppDIContainer.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

final class AppDIContainer {
    
    //MARK: Services
    lazy var networkService: HTTPClient = {
        let urlSession: URLSession = .shared
        let jsonDecoder: JSONDecoder = JSONDecoder()
        return URLSessionHTTPClient(with: urlSession, jsonDecoder: jsonDecoder)
    }()
    
    lazy var imageLoader: ImageFetchable = {
        let urlSession: URLSession = .shared
        return ImageLoader(urlSession: urlSession)
    }()
    
    //MARK: DataSources
    lazy var apiDataSource: APIDataSource = {
        let networkService: HTTPClient = networkService
        return StandardAPIDataSource(networkService: networkService)
    }()
    
    lazy var imageDataSource: ImageDataSource = {
        let imageLoader: ImageFetchable = imageLoader
        return StandardImageDataSource(imageLoader: imageLoader)
    }()
    
    //MARK: Repositories
    lazy var searchRepository: SearchRepository = {
       return StandardSearchRepository(apiDataSource: apiDataSource)
    }()
    
    lazy var imageRepository: ImageRepository = {
       return StandardImageRepository(imageDataSource: imageDataSource)
    }()
    
    //MARK: Scene based DI Containers
    
    func makeSearchMusicSceneDIContainer() -> SearchMusicFlowDependencyProviding {
        return SearchMusicSceneDIContainer(searchRepository: searchRepository, imageRepository: imageRepository)
    }
}
