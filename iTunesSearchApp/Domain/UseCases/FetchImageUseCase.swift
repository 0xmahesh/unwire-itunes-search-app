//
//  FetchImagesUseCase.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

protocol FetchImageUseCase {
    func execute(with url: URL) async throws -> UIImage?
}

final class StandardFetchImageUseCase: FetchImageUseCase {
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func execute(with url: URL) async throws -> UIImage? {
        return try await imageRepository.fetchImageData(url: url)
    }
}


