//
//  UIImage+resizedImage.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit

extension UIImage {
    func resizedImage(Size sizeImage: CGSize) -> UIImage?
    {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
}
