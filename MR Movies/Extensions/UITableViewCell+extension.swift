//
//  UITableViewCell+extension.swift
//  MR Movies
//
//  Created by mac on 06/02/2024.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: .main)
    }
    
    static var cellId: String {
        return String(describing: self)
    }
}
