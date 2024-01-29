//
//  MoviesListViewController.swift
//  MR Movies
//
//  Created by mac on 25/01/2024.
//

import UIKit

class MoviesListViewController: UITableViewController {
    
    let viewModel = MoviesListViewModel()
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var errorMessage: String? {
        didSet {
            presentAlertVC()
        }
    }
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    struct Constants {
        static let MOVIE_CELL_ID = "MovieCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchMovies()
        viewModel.delegate = self
        configureTableView()
        configureNavigationBar()
    }
    
    
    func configureTableView() {
        let nib = UINib(nibName: MovieCell().viewName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.MOVIE_CELL_ID)
    }
    
    func configureNavigationBar() {
        title = NSLocalizedString(StringResources.Movies, comment: "navigation bar title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    }
    
    func presentAlertVC() {
        let errorStr = NSLocalizedString(StringResources.Error, comment: "alert title")
        let okStr = NSLocalizedString(StringResources.Ok, comment: "cancel button text")
        let alertVC = UIAlertController(title: errorStr, message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: okStr, style: .cancel)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: Constants.MOVIE_CELL_ID) as? MovieCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        movieCell.configureCell(model: movie)
        return movieCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            viewModel.fetchMovies()
        }
    }
    
}

extension MoviesListViewController: MoviesListViewModelDelegate {
    func didFetchMovies(movies: [Movie]) {
        self.movies = movies
    }
    
    func error(message: String) {
        self.errorMessage = message
    }
    
    func changeLoading(isLoading: Bool) {
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}
