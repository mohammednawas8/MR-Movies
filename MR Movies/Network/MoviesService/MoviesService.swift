//
//  MoviesService.swift
//  MR Movies
//
//  Created by mac on 25/01/2024.
//

import Foundation
  
protocol MoviesService {
    
    func fetchMovieList(page: Int) async throws -> MovieListResponse
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetailsResponse

}

