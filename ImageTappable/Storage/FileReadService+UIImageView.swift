//
//  FileReadService+UIImageView.swift
//  ImageTappable
//
//  Created by Mangust on 04.05.2025.
//

import UIKit

public extension UIImageView {
    func loadImage(from fileURL: URL) async {
        guard let data = try? Data(contentsOf: fileURL) else {
            print("Error loading image from file: \(fileURL)")
            self.image = nil
            return
        }

        guard let image = UIImage(data: data) else {
            print("Error creating UIImage from data: \(data.count) bytes")
            self.image = nil
            return
        }

        DispatchQueue.main.async {
            self.image = image
        }
    }
}
