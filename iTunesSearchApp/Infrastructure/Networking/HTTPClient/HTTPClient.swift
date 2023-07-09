//
//  HTTPClient.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

protocol HTTPClient {
    func executeRequestWithJSONDecoding<ResponseBody: Decodable>(_ endpoint: APIEndpoint, for type: ResponseBody.Type) async -> Result<(ResponseBody, HTTPURLResponse), NetworkError>
}
