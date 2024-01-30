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
    
    var value: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
