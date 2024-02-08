//
//  MovieDetailsViewController.swift
//  MR Movies
//
//  Created by mac on 01/02/2024.
//

import UIKit

protocol MovieDetailsVCDelegate: AnyObject {
    
    func didAddMovieToFavorites(movie: MovieUIModel)
    
    func didRemoveMovieFromFavorites(movie: MovieUIModel)
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
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureNavigationBar()
    }
    
    func configureViews() {
        configureImages()
        configureMovieInformationViews()
        configureLabels()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.onMovieSaved = { [weak self] movie in
            self?.configureFavoriteButton()
            self?.delegate?.didAddMovieToFavorites(movie: movie)
        }
        
        viewModel.onMovieDeleted = { [weak self] movie in
            self?.configureFavoriteButton()
            self?.delegate?.didRemoveMovieFromFavorites(movie: movie)
        }
    }
    
    func configureImages() {
        guard let movie = viewModel.movie else { return }
        let bannerImageUrl = URL(string: movie.bannerImagePath)
        bannerImageView.kf.setImage(with: bannerImageUrl)
        let posterImageUrl = URL(string: movie.posterImagePath)
        posterImageView.kf.setImage(with: posterImageUrl)
    }
    
    func configureMovieInformationViews() {
        guard let movie = viewModel.movie else { return }
        yearInfoView.infoLabel.text = String(movie.releaseYear)
        durationInfoView.infoLabel.text = String(movie.duration) + StringResources.minutes.value
        genreInfoView.infoLabel.text = movie.genres.joined(separator: ", ")
    }
    
    func configureLabels() {
        guard let movie = viewModel.movie else { return }
        nameLabel.text = movie.name
        overviewLabel.text = movie.overview
    }
    
    func configureNavigationBar() {
        title = StringResources.details.value
        configureFavoriteButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    func configureFavoriteButton() {
        guard let movie = viewModel.movie else { return }
        favoriteButton.tintColor = movie.isSaved ? .systemOrange : .systemBlue
        let image = UIImage(systemName: movie.isSaved ? "bookmark.fill" : "bookmark")
        favoriteButton.setImage(image, for: .normal)
    }
    
    @objc func favoriteTapped() {
        guard let movie = viewModel.movie else { return }
        if movie.isSaved {
            viewModel.deleteMovie(movie)
        } else {
            viewModel.saveMovie(movie)
        }
    }
}
