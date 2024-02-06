//
//  DividerView.swift
//  MR Movies
//
//  Created by mac on 06/02/2024.
//

import UIKit

@IBDesignable class DividerView: UIView {
    
    @IBInspectable var color: UIColor? {
        get {
            return backgroundColor
        }
        set {
            backgroundColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
