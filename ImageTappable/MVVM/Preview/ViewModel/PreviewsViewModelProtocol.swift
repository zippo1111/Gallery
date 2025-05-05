//
//  PreviewsViewModelProtocol.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

protocol PreviewsViewModelProtocol {
    func fetchImages() async -> [PreviewViewModel]?
    func reloadImage(with url: String) async -> PreviewViewModel?
}
