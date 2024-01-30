//
//  MoviesListViewController.swift
//  MR Movies
//
//  Created by mac on 25/01/2024.
//

import UIKit

class MoviesListViewController: UITableViewController {
    
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
        handleFetchingMoviesCallback()
        handleErrorCallback()
    }
    
    
    func configureTableView() {
        let nib = UINib(nibName: MovieCell.Constants.NAME, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MovieCell.Constants.NAME)
    }
    
    func configureNavigationBar() {
        title = StringResources.movies.value
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    }
    
    func handleFetchingMoviesCallback() {
        viewModel.onMoviesFetched = { [weak self] movies in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func handleErrorCallback() {
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

extension MoviesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.Constants.NAME) as? MovieCell else { return UITableViewCell() }
        let movie = viewModel.fetchedMovies[indexPath.row]
        movieCell.configureCell(model: movie)
        return movieCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.fetchedMovies.count - 1 {
            activityIndicatorView.startAnimating()
            viewModel.moviesPaginator.loadNextItems()
        }
    }
}
