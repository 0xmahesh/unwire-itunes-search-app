//
//  ImageLoader.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

actor ImageLoader: ImageFetchable {
    
    private let urlSession: URLSession
    private var images: [URLRequest: ImageLoaderStatus] = [:]
 
    private enum ImageLoaderStatus {
        case inProgress(Task<UIImage?, Error>)
        case fetched(UIImage)
    }
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetch(_ url: URL) async throws -> UIImage? {
        let urlRequest = URLRequest(url: url)
        
        if let status = images[urlRequest] {
            switch status {
            case .inProgress(let task):
                return try await task.value
            case .fetched(let image):
                return image
            }
        }
        
        let task: Task<UIImage?, Error> = Task {
            let (data, _) = try await urlSession.data(for: urlRequest)
            if let image = UIImage(data: data) {
                return image
            } else {
                return nil
            }
        }
        
        images[urlRequest] = .inProgress(task)
        
        if let image = try await task.value {
            images[urlRequest] = .fetched(image)
            return image
        } else {
            return nil
        }
    }

}

