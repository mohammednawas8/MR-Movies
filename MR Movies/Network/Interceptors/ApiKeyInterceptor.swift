//
//  ApiKeyInterceptor.swift
//  MR Movies
//
//  Created by mac on 28/01/2024.
//

import Foundation
import Alamofire

class ApiKeyInterceptor: RequestInterceptor {
    
    let defaultParamerters: [String: String]
    
    init(apiKey: String) {
        defaultParamerters = ["api_key": apiKey]
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        let encoding = URLEncodedFormParameterEncoder.default
        if let request = try? encoding.encode(defaultParamerters, into: urlRequest) {
            urlRequest = request
        }
        completion(.success(urlRequest))
    }
}
