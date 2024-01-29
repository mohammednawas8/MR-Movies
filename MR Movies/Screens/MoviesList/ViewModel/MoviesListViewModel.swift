//
//  MoviesListViewModel.swift
//  MR Movies
//
//  Created by mac on 28/01/2024.
//

import Foundation

protocol MoviesListViewModelDelegate: AnyObject {
    
    func didFetchMovies(movies: [Movie])
    
    func changeLoading(isLoading: Bool)
    
    func error(message: String)
}

class MoviesListViewModel {
        
    weak var delegate: MoviesListViewModelDelegate?
    var moviesService: MoviesService
    
    private var page: Int = 1
    private var totalPages = 1
    private var fetchedMovies = [Movie]() {
        didSet {
            Task {
                await MainActor.run {
                    delegate?.didFetchMovies(movies:fetchedMovies)
                }
            }
        }
    }
    private var isLoading = false {
        didSet {
            Task {
                await MainActor.run {
                    delegate?.changeLoading(isLoading:isLoading)
                }
            }
        }
    }
    
    init(delegate: MoviesListViewModelDelegate? = nil, moviesService: MoviesService = MoviesServiceImpl()) {
        self.delegate = delegate
        self.moviesService = moviesService
    }
    
    //TODO: Create Paginator class
    func fetchMovies() {
        if page > totalPages {
            return
        }
        Task {
            do {
                isLoading = true
                let moviesResponse = try await moviesService.fetchMovieList(page: page)
                totalPages = moviesResponse.totalPages
                let moviesFromCurrentPage = try await withThrowingTaskGroup(of: Movie.self, returning: [Movie].self) { taskGroup in
                    var movies = [Movie]()
                    for movieId in moviesResponse.movieIds {
                        taskGroup.addTask {
                            try await self.moviesService.fetchMovieDetails(movieId: movieId.id).toMovie()
                        }
                    }
                    for try await movie in taskGroup {
                        movies.append(movie)
                    }
                    return movies
                }
                fetchedMovies = fetchedMovies + moviesFromCurrentPage
                page += 1
                isLoading = false
            } catch {
                await MainActor.run {
                    delegate?.error(message: error.localizedDescription)
                }
                isLoading = false
            }
        }
    }
}
