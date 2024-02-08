//
//  ViewController+extension.swift
//  MR Movies
//
//  Created by mac on 07/02/2024.
//

import UIKit

extension UIViewController {
    func instantiateViewControllerByID(_ id: String) -> UIViewController? {
        return storyboard?.instantiateViewController(withIdentifier: id)
    }
}

