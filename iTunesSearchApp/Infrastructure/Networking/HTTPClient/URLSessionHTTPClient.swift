//
//  URLSessionHTTPClient.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    
    private var urlSession: URLSession
    private var jsonDecoder: JSONDecoder
    
    init(with urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func executeRequestWithJSONDecoding<ResponseBody: Decodable>(_ endpoint: APIEndpoint, for type: ResponseBody.Type) async -> Result<(ResponseBody, HTTPURLResponse), NetworkError> {
        
        guard let url = endpoint.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        endpoint.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        jsonDecoder.dateDecodingStrategy = endpoint.dateDecodingStrategy
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode.isSuccessStatusCode else {
                return .failure(.apiError(response))
            }
            
            let responseBody = try jsonDecoder.decode(ResponseBody.self, from: data)
            return .success((responseBody, httpResponse))
            
        } catch let error as URLError {
            return .failure(.networkError(error))
        } catch let error as DecodingError {
            return .failure(.parsingError(error))
        } catch {
            return .failure(.networkError(.init(.unknown)))
        }
    }
}

private extension Int {
    var isSuccessStatusCode: Bool {
        return [200, 201, 202, 203, 204].contains(self)
    }
}
