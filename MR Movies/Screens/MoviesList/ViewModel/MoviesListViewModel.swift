//
//  MoviesListViewModel.swift
//  MR Movies
//
//  Created by mac on 28/01/2024.
//

import Foundation

class MoviesListViewModel {
    
    var onMoviesFetched: (([MovieUIModel]) -> Void)?
    var onError: ((String) -> Void)?
    
    private var moviesService: MoviesService
    
    private (set) var fetchedMovies = [MovieUIModel]()
        
    init(moviesService: MoviesService = MoviesServiceImpl()) {
        self.moviesService = moviesService
    }
    
    lazy var moviesPaginator: Paginator<Int> = {
        return Paginator<Int>(
            initialPage: 1,
            requestItems: { [weak self] page in
                let response = try await self?.moviesService.fetchMovieList(page: page)
                if response?.totalPages == page {
                    return []
                } else {
                    return response?.movieIds.map{ $0.id } ?? []
                }
            },
            onItemsFetched: { [weak self] ids in
                self?.fetchMovieUiModels(ids: ids)
            },
            onError: { [weak self] error in
                self?.onError?(error.localizedDescription)
            }
        )
    }()
    
    private func fetchMovieUiModels(ids: [Int]) {
        Task {
            do {
                let movies = try await withThrowingTaskGroup(
                    of: MovieUIModel.self,
                    returning: [MovieUIModel].self
                ){ taskGroup in
                    var movies = [MovieUIModel]()
                    for id in ids {
                        taskGroup.addTask {
                            try await self.moviesService.fetchMovieDetails(movieId: id).toMovieUiModel()
                        }
                    }
                    for try await movie in taskGroup {
                        movies.append(movie)
                    }
                    return movies
                }
                fetchedMovies = fetchedMovies + movies
                onMoviesFetched?(fetchedMovies)
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
