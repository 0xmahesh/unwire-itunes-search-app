//
//  StandardImageRepository.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

final class StandardImageRepository: ImageRepository {
    
    private let imageDataSource: ImageDataSource
    
    init(imageDataSource: ImageDataSource) {
        self.imageDataSource = imageDataSource
    }
    
    func fetchImageData(url: URL) async throws -> UIImage? {
        return try await imageDataSource.fetchImage(url: url).get()
    }
    
}
