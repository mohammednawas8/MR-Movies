//
//  Formatter.swift
//  MR Movies
//
//  Created by mac on 30/01/2024.
//

import Foundation

struct Formatter {
    static func formatDoubleToOneDecimalString(_ num: Double) -> String {
        return String(format: "%.1f", num)
    }
}
