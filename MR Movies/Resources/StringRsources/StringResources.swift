//
//  StringResources.swift
//  MR Movies
//
//  Created by mac on 29/01/2024.
//

import Foundation

enum StringResources: String {
    case movies
    case error
    case ok
    case details
    case aboutMovie
    case minutes
    case noMovies
    
    var value: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
