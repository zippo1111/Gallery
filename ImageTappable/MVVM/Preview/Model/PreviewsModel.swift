//
//  PreviewsModel.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import UIKit

struct PreviewsModel {
    enum PreviewState: Hashable {
        case downloaded(url: String)
        case autoReload
        case manualReload
    }

    private let converter: Converter?

    init(converter: Converter?) {
        self.converter = converter
    }

    func getAddresses() async -> [String?] {
        await fileReadService.downloadAddresses(from:  Constants.addressesUrl)
    }

    mutating func getImages(from addresses: [String?]) async -> [PreviewModel]? {
        guard let converter = converter else {
            return nil
        }

        let entities = await imagesService.loadImages(from: addresses)

        return entities?.map {
            converter.getStatefullModel(from: $0)
        }
    }

    mutating func getImage(from address: String) async -> PreviewModel? {
        guard let entity = try? await imagesService.loadAndSaveImageIfNotInCache(for: address) else {
            return nil
        }

        return converter?.getStatefullModel(from: entity)
    }

    private lazy var imagesService = ImagesService(downloadService: downloaderService, imageSaveService: imageSaveService)
    private var downloaderService = ImageDownloaderService()
    private let fileReadService = FileReadService()
    private let imageSaveService = FileSaveService()
}

fileprivate extension PreviewsModel {
    enum Constants {
        static let addressesUrl = "addresses.txt"
    }
}
