//
//  PreviewsViewModel.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import UIKit

final class PreviewsViewModel: PreviewsViewModelProtocol {
    func fetchImagesIfNeeded() async -> [PreviewViewModel]? {
        nil
    }

    func fetchImages() async -> [PreviewViewModel]? {
        let addresses: [String?] = await model.getAddresses()

        guard !addresses.isEmpty,
              let response = await model.getImages(from: addresses)
        else {
            return nil
        }

        return response.map {
            PreviewViewModel(
                url: $0.url,
                state: $0.state
            )
        }
    }

    func reloadImage(with url: String) async -> PreviewViewModel? {
        guard let response = await model.getImage(from: url) else {
            return nil
        }

        return PreviewViewModel(
            url: response.url,
            state: response.state
        )
    }

    private var model = PreviewsModel(converter: Converter())
}
