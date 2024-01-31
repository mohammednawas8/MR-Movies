//
//  MoviesServiceImpl.swift
//  MR Movies
//
//  Created by mac on 25/01/2024.
//

import Foundation
import Alamofire

class MoviesServiceImpl: MoviesService {
    
    private let apiKeyInterceptor: ApiKeyInterceptor
    private let session: Session
        
    init() {
        apiKeyInterceptor = ApiKeyInterceptor(apiKey: Constants.API_KEY)
        session = Session(interceptor: apiKeyInterceptor)
    }
    
    struct Constants {
        static let API_KEY = "e84676053a18b1eefde4c7d28bce5882"
        static let BASE_URL = "https://api.themoviedb.org/3/"
        static let MOVIE_LIST_END_POINT = BASE_URL + "discover/movie"
        static let MOVIE_DETAILS_END_POINT = BASE_URL + "movie/{movie_id}"
        static let IMAGE_PREFIX = "https://image.tmdb.org/t/p/w500"
    }
    
    func fetchMovieList(page: Int) async throws -> MovieListResponse {
        let parameters = ["page": String(page)]
        let request = session.request(Constants.MOVIE_LIST_END_POINT, parameters: parameters)
        let response = try await request.serializingDecodable(MovieListResponse.self).value
        return response
    }
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetailsResponse {
        let movieDetailsEndPoint = Constants.MOVIE_DETAILS_END_POINT.replacingOccurrences(of: "{movie_id}", with: String(movieId))
        let request = session.request(movieDetailsEndPoint)
        let response = try await request.serializingDecodable(MovieDetailsResponse.self).value
        return response
    }
}
