//
//  MovieRepositoryImpl.swift
//  MR Movies
//
//  Created by mac on 07/02/2024.
//

import Foundation
import CoreData

class MovieRepositoryImpl: MovieRepository {
    
    private var movieService: MovieService
    private var movieDataManager: MovieDataManager
    
    private init(movieService: MovieService, movieDataManager: MovieDataManager = MovieDataManager.shared) {
        self.movieService = movieService
        self.movieDataManager = movieDataManager
    }
    
    static func createInstance(movieSerivce: MovieService = MovieServiceImpl.shared) -> MovieRepository {
        return MovieRepositoryImpl(movieService: movieSerivce)
    }
    
    func fetchRemoteMovies(page: Int) async throws -> [MovieUIModel] {
        let response = try await movieService.fetchMovieList(page: page)
        return try await withThrowingTaskGroup(of: MovieUIModel.self, returning: [MovieUIModel].self) { taskGroup in
            var movies = [MovieUIModel]()
            for movieId in response.movieIds {
                taskGroup.addTask {
                    try await self.movieService.fetchMovieDetails(movieId: movieId.id).toMovieUiModel()
                }
            }
            for try await movie in taskGroup {
                var mutableMovie = movie
                if fetchSavedMovieById(mutableMovie.id) != nil {
                    mutableMovie.isSaved = true
                }
                movies.append(mutableMovie)
            }
            return movies
        }
    }
    
    func fetchLocalMovies() -> [MovieUIModel] {
        return movieDataManager.fetchMovies()
    }
    
    func fetchSavedMovieById(_ id: Int) -> MovieUIModel? {
        return movieDataManager.fetchMovieById(id)
    }
    
    func saveMovie(movie: MovieUIModel) -> Bool {
        return movieDataManager.saveMovie(movie: movie)
    }
    
    
    func deleteMovie(movie: MovieUIModel) -> Bool {
        return movieDataManager.deleteMovie(movie: movie)
    }
}
