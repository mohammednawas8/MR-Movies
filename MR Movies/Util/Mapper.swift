//
//  Mapper.swift
//  MR Movies
//
//  Created by mac on 07/02/2024.
//

import Foundation

class Mapper {
    static func fromMovieDataToMovieUI(_ movie: MovieDataModel, isSaved: Bool) -> MovieUIModel {
        return MovieUIModel(
            id: Int(movie.id),
            name: movie.name ?? "",
            rating: movie.rating ?? "",
            genres: movie.genres?.components(separatedBy: ", ") ?? [],
            releaseYear: movie.releaseYear ?? "",
            posterImagePath: movie.posterImagePath ?? "",
            bannerImagePath: movie.bannerImagePath ?? "",
            overview: movie.overview ?? "",
            duration: Int(movie.duration),
            isSaved: isSaved
        )
    }
}
