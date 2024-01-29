//
//  MovieCell.swift
//  MR Movies
//
//  Created by mac on 28/01/2024.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    
    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var genreLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configureCell(model: Movie) {
        nameLabel.text = model.name
        ratingLabel.text = model.rating
        genreLabel.text = model.genres.joined(separator: ", ")
        yearLabel.text = model.releaseYear
        durationLabel.text = String(model.duration)
        let url = URL(string: model.imagePath)
        movieImageView.kf.setImage(with: url)
    }
}
