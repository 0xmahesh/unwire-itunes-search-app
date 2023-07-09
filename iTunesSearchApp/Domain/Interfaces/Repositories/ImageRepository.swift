//
//  ImageRepository.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

protocol ImageRepository {
    func fetchImageData(url: URL) async throws -> UIImage?
}
