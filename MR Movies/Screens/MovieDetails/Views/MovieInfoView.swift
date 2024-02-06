//
//  MovieInfoView.swift
//  MR Movies
//
//  Created by mac on 01/02/2024.
//

import UIKit

@IBDesignable class MovieInfoView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    
    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }

        set {
            imageView.image = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        view = loadViewFromNib()
        view.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
}
