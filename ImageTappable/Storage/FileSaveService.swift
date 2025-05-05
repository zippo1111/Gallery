//
//  FileSaveService.swift
//  ImageTappable
//
//  Created by Mangust on 04.05.2025.
//

import Foundation
import UIKit

struct FileSaveService {
    let converter = Converter()

    func saveIfNotExists(image: UIImage, name: String) -> URL? {
        let hashedName = converter.getHashedValue(from: name)

        guard let _ = getCachedFileNameIfExists(hashedName)
        else {
            return save(
                image: image,
                name: hashedName
            )
        }

        return nil
    }

    private func save(image: UIImage, name: String) -> URL? {
        guard let path = try? savePng(image, name: name) else {
            return try? saveJpg(image, name: name)
        }

        return path
    }
}

extension FileSaveService {
    func isFileExists(hashedFileName: String) -> Bool {
        guard let path = getDocumentsDirectory()?.appendingPathComponent(hashedFileName).path
        else {
            return false
        }

        return FileManager.default.fileExists(atPath: path)
    }

    func getCachedFileNameIfExists(_ address: String) -> String? {
        let pngFilename = converter.getHashedValue(from: address)+Constants.extensionPNG
        let jpgFilename = converter.getHashedValue(from: address)+Constants.extensionJPG

        if isFileExists(hashedFileName: pngFilename) {
            return pngFilename
        } else if isFileExists(hashedFileName: jpgFilename) {
            return jpgFilename
        }

        return nil
    }

    func getDocumentsDirectory() -> URL? {
        let path = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return path.first
    }

    func savePng(_ image: UIImage, name: String) throws -> URL? {
        guard let pngData = image.pngData() else {
            return nil
        }

        return try? save(with: name+Constants.extensionPNG, data: pngData)
    }

    func saveJpg(_ image: UIImage, name: String, quality: CGFloat = 0.8) throws -> URL? {
        guard let jpgData = image.jpegData(compressionQuality: quality) else {
            return nil
        }

        return try? save(with: name+Constants.extensionJPG, data: jpgData)
    }

    func save(with filename: String, data: Data) throws -> URL? {
        guard let path = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            return nil
        }

        do {
            try data.write(to: path)
            return path
        } catch {
            throw error
        }
    }

    enum Constants {
        static let extensionJPG = ".jpg"
        static let extensionPNG = ".png"
    }
}
