//
//  MovieDetailsViewController.swift
//  MR Movies
//
//  Created by mac on 01/02/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var yearInfoView: MovieInfoView!
    @IBOutlet var durationInfoView: MovieInfoView!
    @IBOutlet var genreInfoView: MovieInfoView!
    @IBOutlet var overviewLabel: UILabel!
    
    
    var movie: MovieUIModel = MovieUIModel(
        name: "Spider Man far away from home",
        rating: "8.2",
        genres: ["action","advanture"],
        releaseYear: "2019",
        posterImagePath: "https://m.media-amazon.com/images/M/MV5BZWMyYzFjYTYtNTRjYi00OGExLWE2YzgtOGRmYjAxZTU3NzBiXkEyXkFqcGdeQXVyMzQ0MzA0NTM@._V1_FMjpg_UX1000_.jpg",
        bannerImagePath: "https://thecosmiccircus.com/wp-content/uploads/2022/06/tobeyyyyy-e1654915118777.jpg",
        overview: "Placeholder text that exemplifies the kind of content that should appear, helps reduce cognitive load. For instance, if a given entry field has a label next to it: The label element describes the kind of content that needs to appear.",
        duration: 127)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringResources.details.value
        configureViews()
    }

    func configureViews() {
        configureImages()
        configureMovieInformationViews()
        configureLabels()
    }
    
    func configureImages() {
        let bannerImageUrl = URL(string: movie.bannerImagePath)
        bannerImageView.kf.setImage(with: bannerImageUrl)
        let posterImageUrl = URL(string: movie.posterImagePath)
        posterImageView.kf.setImage(with: posterImageUrl)
    }
    
    func configureMovieInformationViews() {
        yearInfoView.infoLabel.text = String(movie.releaseYear)
        durationInfoView.infoLabel.text = String(movie.duration) + StringResources.minutes.value
        genreInfoView.infoLabel.text = movie.genres.joined(separator: ", ")
    }
    
    func configureLabels() {
        nameLabel.text = movie.name
        overviewLabel.text = movie.overview
    }
}
