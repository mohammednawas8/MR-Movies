//
//  FormattingExt.swift
//  MR Movies
//
//  Created by mac on 29/01/2024.
//

import Foundation

extension Double {
    func asOneDecimalString() -> String {
        return String(format: "%.1f", self)
    }
}
