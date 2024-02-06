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
    let overview: String
    let bannerImagePath: String
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case genres
        case imagePath = "poster_path"
        case rating = "vote_average"
        case releaseDate = "release_date"
        case duration = "runtime"
        case overview
        case bannerImagePath = "backdrop_path"
    }
}

class GenereResponse: Decodable {
    let name: String
    let id: Int
}

extension MovieDetailsResponse {
    func toMovieUiModel() -> MovieUIModel {
        let genres = self.genres.map { $0.name }
        let year = releaseDate.components(separatedBy: "-")[0]
        let rating = Formatter.formatDoubleToOneDecimalString(rating)
        return MovieUIModel(
            name: title,
            rating: rating,
            genres: genres,
            releaseYear: year,
            posterImagePath: MoviesServiceImpl.Constants.IMAGE_PREFIX + imagePath,
            bannerImagePath: bannerImagePath,
            overview: overview,
            duration: duration
        )
    }
}
