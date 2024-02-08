//
//  MoviesListViewController.swift
//  MR Movies
//
//  Created by mac on 25/01/2024.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var switchView: UISwitch!
    
    let viewModel = MoviesListViewModel()
        
    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
        activityIndicatorView.startAnimating()
        viewModel.moviesPaginator.loadNextItems()
        bindViewModel()
    }
    
    @IBAction func favoriteSwitchTapped(_ sender: UISwitch) {
        viewModel.isFavoriteMovies = switchView.isOn
        tableView.reloadData()
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.cellId)
    }
    
    func configureNavigationBar() {
        title = StringResources.movies.value
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    }
    
    func bindViewModel() {
        viewModel.onMoviesFetched = { [weak self] movies in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.presentAlertVC(title: StringResources.error.value, message: error)
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func presentAlertVC(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: StringResources.ok.value, style: .cancel)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellId) as? MovieCell else { return UITableViewCell() }
        let movie = viewModel.movies[indexPath.row]
        movieCell.configureCell(model: movie)
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.count - 1 && !viewModel.isFavoriteMovies {
            activityIndicatorView.startAnimating()
            viewModel.moviesPaginator.loadNextItems()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsVC = instantiateViewControllerByID(MovieDetailsViewController.Constants.StoryboardID)
                as? MovieDetailsViewController else { return }
        let movie = viewModel.movies[indexPath.row]
        detailsVC.viewModel.movie = movie
        detailsVC.delegate = self
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

extension MoviesListViewController: MovieDetailsVCDelegate {
    
    func didAddMovieToFavorites(movie: MovieUIModel) {
        viewModel.addFavoriteMarkToMovie(movie)
        tableView.reloadData()
    }
    
    func didRemoveMovieFromFavorites(movie: MovieUIModel) {
        viewModel.removeFavoriteMarkFromMovie(movie)
        tableView.reloadData()
    }
    
}
