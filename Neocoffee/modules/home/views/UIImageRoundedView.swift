//
//  UIImageRoundedView.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit

class UIImageRoundedView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: "border")!.cgColor
        layer.masksToBounds = true
    }
}
