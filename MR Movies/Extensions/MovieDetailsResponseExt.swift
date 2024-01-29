//
//  MovieDetailsResponseExt.swift
//  MR Movies
//
//  Created by mac on 28/01/2024.
//

import Foundation

extension MovieDetailsResponse {
    func toMovie() -> Movie {
        let genres = self.genres.map { $0.name }
        let year = releaseDate.components(separatedBy: "-")[0]
        return Movie(name: title, rating: rating.asOneDecimalString(), genres: genres, releaseYear: year, imagePath: "https://image.tmdb.org/t/p/w500\(imagePath)", duration: duration)
    }
}
