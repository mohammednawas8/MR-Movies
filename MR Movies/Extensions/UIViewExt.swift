//
//  UIViewExt.swift
//  MR Movies
//
//  Created by mac on 28/01/2024.
//

import UIKit

extension UIView {
    var viewName: String {
        String(describing: type(of: self))
    }
}
