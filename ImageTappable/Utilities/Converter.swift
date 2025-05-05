//
//  Converter.swift
//  ImageTappable
//
//  Created by Mangust on 05.05.2025.
//

import Foundation

struct Converter {
    func getHashedValue(from text: String) -> String {
        var changed = text.unicodeScalars
        changed.removeAll(where: CharacterSet.punctuationCharacters.contains)
        return changed.description
    }

    func getStatefullModel(from entity: PreviewEntity) -> PreviewModel {
        var state: PreviewsModel.PreviewState?

        if entity.hasNoInternetConnection == true, entity.isNotLoaded == true {
            state = .autoReload
        } else if entity.hasNoInternetConnection == false, entity.isNotLoaded == true {
            state = .manualReload
        } else if let url = entity.url, !url.absoluteString.isEmpty {
            state = .downloaded(url: url.absoluteString)
        }

        var downloadedUrl: String?

        if case let .downloaded(url) = state {
            downloadedUrl = url
        }

        return PreviewModel(
            state: state,
            url: downloadedUrl ?? entity.url?.absoluteString
        )
    }
}
