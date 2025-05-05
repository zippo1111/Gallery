//
//  ImagesService.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import Foundation
import UIKit

struct ImagesService {
    private let downloadService: ImageDownloaderService?
    private let imageSaveService: FileSaveService?

    init(downloadService: ImageDownloaderService?, imageSaveService: FileSaveService?) {
        self.downloadService = downloadService
        self.imageSaveService = imageSaveService
    }
}

extension ImagesService {
    func loadImages(from imageAddresses: [String?]) async -> [PreviewEntity]? {
        var images: [PreviewEntity]? = []

        for address in imageAddresses {
            var isNotLoaded = false
            var hasNoInternetConnection = false

            do {
                let entity = try await loadAndSaveImageIfNotInCache(for: address)
                images?.append(entity)
            } catch {
                if let urlError = error as? URLError {
                    if urlError.code == .notConnectedToInternet {
                        hasNoInternetConnection = true
                    } else {
                        isNotLoaded = true
                    }
                } else {
                    isNotLoaded = true
                }

                let url = address != nil ? URL(string: address!) : nil

                let entity = PreviewEntity(url: url, isNotLoaded: isNotLoaded, hasNoInternetConnection: hasNoInternetConnection)
                images?.append(entity)
            }
        }

        return images
    }

    func isURLReturningImage(url: URL) async -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
                return contentType.lowercased().hasPrefix("image/")
            }
        } catch {
            return false
        }

        return false
    }


    func loadAndSaveImageIfNotInCache(for address: String?) async throws -> PreviewEntity {
        guard let address = address, !address.isEmpty else {
            return PreviewEntity(url: nil, isNotLoaded: true, hasNoInternetConnection: false)
        }

        let url = URL(string: address)

        do {
            let notLoadedEntity = PreviewEntity(url: url, isNotLoaded: true, hasNoInternetConnection: false)

            guard let fileUrl = await downloadAndSaveIfNotInCache(for: address) else {
                return notLoadedEntity
            }

            return PreviewEntity(url: fileUrl, isNotLoaded: false, hasNoInternetConnection: false)
        }
    }
}

fileprivate extension ImagesService {
    func downloadAndSaveIfNotInCache(for address: String) async -> URL? {
        guard let cached = imageSaveService?.getCachedFileNameIfExists(address)
        else {
            guard let url = URL(string: address),
                  await isURLReturningImage(url: url) == true
            else {
                return nil
            }

            guard let image = try? await downloadService?.downloadImage(from: url) else {
                return nil
            }

            let fileUrl = imageSaveService?.saveIfNotExists(image: image, name: address)

            return fileUrl
        }

        return imageSaveService?.getDocumentsDirectory()?.appendingPathComponent(cached)
    }
}
