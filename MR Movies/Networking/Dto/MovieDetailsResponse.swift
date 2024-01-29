//
//  MovieDetailsResponse.swift
//  MR Movies
//
//  Created by mac on 25/01/2024.
//

import Foundation

struct MovieDetailsResponse: Decodable {
    let title: String
    let genres: [GenereResponse]
    let imagePath: String
    let rating: Double
    let releaseDate: String
    let duration: Int
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case genres
        case imagePath = "poster_path"
        case rating = "vote_average"
        case releaseDate = "release_date"
        case duration = "runtime"
    }
}

class GenereResponse: Decodable {
    let name: String
    let id: Int
}