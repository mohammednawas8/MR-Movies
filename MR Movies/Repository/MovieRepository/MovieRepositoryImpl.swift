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
                if fetchFavoriteMovieById(mutableMovie.id) != nil {
                    mutableMovie.isSaved = true
                }
                movies.append(mutableMovie)
            }
            return movies
        }
    }
    
    func fetchFavoriteMovies() -> [MovieUIModel] {
        return movieDataManager
            .fetchMovies()
            .map { Mapper.fromMovieDataToMovieUI($0, isSaved: true) }
    }
    
    func fetchFavoriteMovieById(_ id: Int) -> MovieUIModel? {
        guard let movieDataModel = movieDataManager.fetchFavoriteMovieById(id) else { return nil }
        return Mapper.fromMovieDataToMovieUI(movieDataModel, isSaved: true)
    }
    
    func saveMovieToFavorites(movie: MovieUIModel) -> Bool {
        return movieDataManager.saveMovieToFavorites(movie: movie)
    }
    
    func deleteMovieFromFavorites(movie: MovieUIModel) -> Bool {
        return movieDataManager.deleteMovieFromFavorites(id: movie.id)
    }
}
