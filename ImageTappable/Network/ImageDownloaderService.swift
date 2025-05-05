//
//  ImageDownloaderService.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import UIKit

enum NetworkError: Error {
    case noInternetConnection
}

struct ImageDownloaderService {
    private let configuration = URLSessionConfiguration.default
    private var session: URLSession?

    init() {
        configureNetwork()
    }

    func downloadImage(from url: URL?) async throws -> UIImage {
        do {
            guard let url = url else {
                throw URLError(.badURL)
            }

            guard let session = session else {
                throw URLError(.unknown)
            }

            let (data, _) = try await session.data(from: url)

            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }

            return image
        } catch {
            if let urlError = error as? URLError {
                if urlError.code == .notConnectedToInternet {
                    throw NetworkError.noInternetConnection
                } else {
                    throw urlError
                }
            } else {
                throw error
            }
        }
    }
}

fileprivate extension ImageDownloaderService {
    mutating func configureNetwork() {
        configuration.waitsForConnectivity = true // Waits if there is no internet
        session = URLSession(configuration: configuration)
    }
}
