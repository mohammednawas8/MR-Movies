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
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.MOVIE_DATA_MODEl)
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unable to load Movie Core Model \(error)")
            }
        }
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    private init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    static func createInstance(movieSerivce: MovieService = MovieServiceImpl.shared) -> MovieRepository {
        return MovieRepositoryImpl(movieService: movieSerivce)
    }
    
    func fetchRemoteMovies(page: Int) async throws -> [MovieUIModel] {
        let response = try await movieService.fetchMovieList(page: page)
        let movies = try await withThrowingTaskGroup(of: MovieUIModel.self, returning: [MovieUIModel].self) { taskGroup in
            var movies = [MovieUIModel]()
            for movieId in response.movieIds {
                taskGroup.addTask {
                    try await self.movieService.fetchMovieDetails(movieId: movieId.id).toMovieUiModel()
                }
            }
            for try await movie in taskGroup {
                var mutableMovie = movie
                if let _ = fetchSavedMovieById(mutableMovie.id) {
                    mutableMovie.setIsSaved(true)
                }
                movies.append(mutableMovie)
            }
            return movies
        }
        return movies
    }
    
    func fetchLocalMovies() -> [MovieUIModel] {
        do {
            let request = MovieDataModel.fetchRequest()
            let models = try context.fetch(request)
            return models
                .map { Mapper.fromMovieDataToMovieUI($0, isSaved: true) }
                .reversed()
        } catch {
            print("Cannot fetch movies \(error)")
            return []
        }
    }
    
    func fetchSavedMovieById(_ id: Int) -> MovieUIModel? {
        let request = MovieDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", id)
        do {
            guard let movieData = try context.fetch(request).first else { return nil }
            return Mapper.fromMovieDataToMovieUI(movieData, isSaved: true)
        } catch {
            print("Cannot fetch Movie by id \(error)")
            return nil
        }
    }
    
    func saveMovie(movie: MovieUIModel) -> Bool {
        let movieData = MovieDataModel(context: context)
        movieData.id = Int64(movie.id)
        movieData.name = movie.name
        movieData.rating = movie.rating
        movieData.genres = movie.genres.joined(separator: ", ")
        movieData.releaseYear = movie.releaseYear
        movieData.posterImagePath = movie.posterImagePath
        movieData.bannerImagePath = movie.bannerImagePath
        movieData.overview = movie.overview
        movieData.duration = Int64(movie.duration)
        return saveContext()
    }
    
    
    func deleteMovie(movie: MovieUIModel) -> Bool {
        let request = MovieDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", movie.id)
        do {
            if let movieData = try context.fetch(request).first {
                context.delete(movieData)
                return saveContext()
            }
        } catch {
            print("Cannot delete item \(error)")
            return false
        }
        return false
    }
    
    private func saveContext() -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                print("An error occurred while saving: \(error)")
                return false
            }
        }
        return false
    }
}
