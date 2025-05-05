//
//  FileReadService.swift
//  ImageTappable
//
//  Created by Mangust on 04.05.2025.
//

import Foundation

struct FileReadService {
    func downloadAddresses(from filePath: String) async -> [String?] {
        guard let string = filePath.contentsOrNil() else {
            return []
        }

        return string.components(separatedBy: "\n")
    }
}

fileprivate extension String {
    func contentsOrNil() -> String? {
        guard let path = Bundle.main.path(forResource: self, ofType: nil)
        else {
            return nil
        }

        do {
            let text = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return text
        } catch {
            return nil
        }
    }
}
