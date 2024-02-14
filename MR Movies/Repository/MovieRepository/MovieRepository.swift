//
//  MovieRepository.swift
//  MR Movies
//
//  Created by mac on 07/02/2024.
//

import Foundation

protocol MovieRepository {
    
    func fetchRemoteMovies(page: Int) async throws -> [MovieUIModel]
    
    func fetchFavoriteMovies() -> [MovieUIModel]
    
    func fetchFavoriteMovieById(_ id: Int) -> MovieUIModel?
    
    func saveMovieToFavorites(movie: MovieUIModel) -> Bool
    
    func deleteMovieFromFavorites(movie: MovieUIModel) -> Bool
    
}
