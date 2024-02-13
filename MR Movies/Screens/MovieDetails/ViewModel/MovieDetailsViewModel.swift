//
//  MovieDetailsViewModel.swift
//  MR Movies
//
//  Created by mac on 07/02/2024.
//

import Foundation

class MovieDetailsViewModel {
    
    var onMovieSaved: ((MovieUIModel) -> Void)?
    var onMovieDeleted: ((MovieUIModel) -> Void)?
    
    let moviesRepository: MovieRepository
    
    var movie: MovieUIModel?
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl.createInstance()) {
        self.moviesRepository = movieRepository
    }
    
    func saveMovie(_ movie: MovieUIModel) {
        let saveResult = moviesRepository.saveMovie(movie: movie)
        if saveResult {
            self.movie?.isSaved = true
            onMovieSaved?(movie)
        }
    }
    
    func deleteMovie(_ movie: MovieUIModel) {
        let deleteResult = moviesRepository.deleteMovie(movie: movie)
        if deleteResult {
            self.movie?.isSaved = false
            onMovieDeleted?(movie)
        }
    }
}
