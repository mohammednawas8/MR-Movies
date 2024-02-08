//
//  MovieRepository.swift
//  MR Movies
//
//  Created by mac on 07/02/2024.
//

import Foundation

protocol MovieRepository {
    
    func fetchRemoteMovies(page: Int) async throws -> [MovieUIModel]
    
    func fetchLocalMovies() -> [MovieUIModel]
    
    func fetchSavedMovieById(_ id: Int) -> MovieUIModel?
    
    func saveMovie(movie: MovieUIModel) -> Bool
    
    func deleteMovie(movie: MovieUIModel) -> Bool
    
}
