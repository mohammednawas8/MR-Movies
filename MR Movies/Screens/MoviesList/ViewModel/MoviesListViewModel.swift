//
//  MoviesListViewModel.swift
//  MR Movies
//
//  Created by mac on 28/01/2024.
//

import Foundation

class MoviesListViewModel {
    
    var onMoviesFetched: (([MovieUIModel]) -> Void)?
    var onEmptyMovies: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    private var movieRepository: MovieRepository
    
    private (set) var movies = [MovieUIModel]() {
        didSet {
            onEmptyMovies?(movies.isEmpty)
        }
    }
    private var remoteMovies = [MovieUIModel]()
    
    var isFavoriteMovies: Bool = false {
        didSet {
            if isFavoriteMovies {
                movies = movieRepository.fetchLocalMovies()
            } else {
                movies = remoteMovies
            }
        }
    }
        
    init(movieRepository: MovieRepository = MovieRepositoryImpl.createInstance()) {
        self.movieRepository = movieRepository
    }
    
    lazy var moviesPaginator: Paginator<MovieUIModel> = {
        return Paginator<MovieUIModel>(
            initialPage: 1,
            requestItems: { [weak self] page in
                guard let self = self else { return [] }
                return try await self.movieRepository.fetchRemoteMovies(page: page)
            },
            onItemsFetched: { [weak self] movies in
                guard let self = self else { return }
                self.remoteMovies = self.remoteMovies + movies
                if !isFavoriteMovies {
                    self.movies = self.remoteMovies
                    onMoviesFetched?(remoteMovies)
                }
            },
            onError: { [weak self] error in
                self?.onError?(error.localizedDescription)
            }
        )
    }()
    
    func addFavoriteMarkToMovie(_ movie: MovieUIModel) {
        guard let indexInMoviesList = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        guard let indexInRemoteMoviesList = remoteMovies.firstIndex(where: { $0.id == movie.id }) else { return }
        movies[indexInMoviesList].isSaved = true
        remoteMovies[indexInRemoteMoviesList].isSaved = true
    }
    
    func removeFavoriteMarkFromMovie(_ movie: MovieUIModel) {
        guard let indexInMoviesList = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        guard let indexInRemoteMoviesList = remoteMovies.firstIndex(where: { $0.id == movie.id }) else { return }
        if isFavoriteMovies {
            movies.remove(at: indexInMoviesList)
        } else {
            movies[indexInMoviesList].isSaved = false
        }
        remoteMovies[indexInRemoteMoviesList].isSaved = false
    }
}
