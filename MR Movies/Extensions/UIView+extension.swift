//
//  UIView+extensions.swift
//  MR Movies
//
//  Created by mac on 01/02/2024.
//

import UIKit

extension UIView {
    
    var viewName: String {
        return String(describing: type(of: self))
    }
    
    func loadViewFromNib() -> UIView {
        return UINib(nibName: viewName, bundle: .main)
            .instantiate(withOwner: self).first as? UIView ?? UIView()
    }
    
}
