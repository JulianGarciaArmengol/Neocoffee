//
//  UIImageWithTimer.swift
//  Neocoffee
//
//  Created by julian.garcia on 01/08/24.
//

import UIKit

class UIImageWithTimer: UIImageView {
    
    var images: [UIImage]? {
        didSet {
            guard let images, !images.isEmpty else { return }
            image = images.first!
        }
    }
    
    private var timer: Timer?

    private var timeInterval: Double = 5
    
    private var currentImageIndex = 0
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    convenience init(image: UIImage?, timeInterval: Double = 5) {
        self.init(image: image)
        
        timer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(nextImage),
            userInfo: nil,
            repeats: true
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func nextImage() {
        guard let images else { return }
        
        let count = images.count
                
        currentImageIndex = (currentImageIndex + 1) % count
        
        image = images[currentImageIndex]
    }
}
