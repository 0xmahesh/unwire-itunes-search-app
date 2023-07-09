//
//  StandardImageDataSource.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

final class StandardImageDataSource: ImageDataSource {

    private let imageLoader: ImageFetchable
    
    init(imageLoader: ImageFetchable) {
        self.imageLoader = imageLoader
    }
    
    func fetchImage(url: URL) async -> Result<UIImage?, Error> {
        do {
            return .success(try await imageLoader.fetch(url))
        } catch let error {
            return .failure(error)
        }
    }
    
}
