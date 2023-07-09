//
//  ImageFetchable.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

protocol ImageFetchable {
    func fetch(_ url: URL) async throws -> UIImage?
}
