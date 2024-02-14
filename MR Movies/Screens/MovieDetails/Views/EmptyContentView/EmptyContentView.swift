//
//  EmptyContentView.swift
//  MR Movies
//
//  Created by mac on 14/02/2024.
//

import UIKit

class EmptyContentView: UIView {
    
    @IBOutlet var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        addSubview(view)
    }
}
