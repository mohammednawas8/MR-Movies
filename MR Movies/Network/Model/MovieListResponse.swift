//
//  MoviesResponse.swift
//  MR Movies
//
//  Created by mac on 25/01/2024.
//

import Foundation

struct MovieListResponse: Decodable {
    let page: Int
    let movieIds: [MovieId]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movieIds = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieId: Decodable {
    let id: Int
} 
