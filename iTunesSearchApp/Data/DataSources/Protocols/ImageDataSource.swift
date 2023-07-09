//
//  ImageDataSource.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

protocol ImageDataSource {
    func fetchImage(url: URL) async -> Result<UIImage?, Error>
}
