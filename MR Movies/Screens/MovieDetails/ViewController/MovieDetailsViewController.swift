//
//  MovieDetailsViewController.swift
//  MR Movies
//
//  Created by mac on 01/02/2024.
//

import UIKit

protocol MovieDetailsVCDelegate: AnyObject {
    
    func didChangeFavoriateMovieStatus(movie: MovieUIModel, isSavedToFavorites: Bool)
}

class MovieDetailsViewController: UIViewController {
    
    struct Constants {
        static let StoryboardID = "DetailsVC"
    }
    
    weak var delegate: MovieDetailsVCDelegate?
    
    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var yearInfoView: MovieInfoView!
    @IBOutlet var durationInfoView: MovieInfoView!
    @IBOutlet var genreInfoView: MovieInfoView!
    @IBOutlet var overviewLabel: UILabel!
        
    let viewModel = MovieDetailsViewModel()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.addAction( UIAction { [weak self] _ in
            self?.favoriteButtonTapped()
        }, for: .primaryActionTriggered)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureNavigationBar()
    }
    
    func configureViews() {
        guard let movie = viewModel.movie else { return }
        configureImages(
            bannerImageUrl: movie.bannerImagePath,
            posterImageUrl: movie.posterImagePath
        )
        
        configureMovieInformationViews(
            releaseYear: movie.releaseYear,
            duration: movie.duration,
            genres: movie.genres
        )

        configureLabels(
            name: movie.name,
            overview: movie.overview
        )
        
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.onMovieSaved = { [weak self] movie in
            self?.configureFavoriteButton(isSaved: true)
            self?.delegate?.didChangeFavoriateMovieStatus(movie: movie, isSavedToFavorites: true)
        }
        
        viewModel.onMovieDeleted = { [weak self] movie in
            self?.configureFavoriteButton(isSaved: false)
            self?.delegate?.didChangeFavoriateMovieStatus(movie: movie, isSavedToFavorites: false)
        }
    }
    
    func configureImages(bannerImageUrl: String, posterImageUrl: String) {
        bannerImageView.kf.setImage(with: URL(string: bannerImageUrl))
        posterImageView.kf.setImage(with: URL(string: posterImageUrl))
    }
    
    func configureMovieInformationViews(releaseYear: String, duration: Int, genres: [String]) {
        yearInfoView.infoLabel.text = releaseYear
        durationInfoView.infoLabel.text = String(duration) + StringResources.minutes.value
        genreInfoView.infoLabel.text = genres.joined(separator: ", ")
    }
    
    func configureLabels(name: String, overview: String) {
        nameLabel.text = name
        overviewLabel.text = overview
    }
    
    func configureNavigationBar() {
        guard let movie = viewModel.movie else { return }
        title = StringResources.details.value
        configureFavoriteButton(isSaved: movie.isSaved)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }

    func configureFavoriteButton(isSaved: Bool) {
        favoriteButton.tintColor = isSaved ? .systemOrange : .systemBlue
        let systemName = isSaved ? "bookmark.fill" : "bookmark"
        let image = UIImage(systemName: systemName)
        favoriteButton.setImage(image, for: .normal)
    }
    
    func favoriteButtonTapped() {
        guard let movie = viewModel.movie else { return }
        if movie.isSaved {
            viewModel.deleteMovieFromFavorites(movie)
        } else {
            viewModel.saveMovieToFavorites(movie)
        }
    }
}
