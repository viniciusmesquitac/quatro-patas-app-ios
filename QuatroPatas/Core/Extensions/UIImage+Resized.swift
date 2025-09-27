//
//  UIImage+Resized.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/09/25.
//

import UIKit

extension UIImage {
    func resized(toMax dimension: CGFloat = 1024) -> UIImage {
        let aspectRatio = size.width / size.height
        var newSize: CGSize
        if aspectRatio > 1 {
            newSize = CGSize(width: dimension, height: dimension / aspectRatio)
        } else {
            newSize = CGSize(width: dimension * aspectRatio, height: dimension)
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func compressed() -> Data? {
        self.resized().jpegData(compressionQuality: 0.5)
    }
}

