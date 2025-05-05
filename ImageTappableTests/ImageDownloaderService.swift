//
//  ImageDownloaderServiceTests.swift
//  ImageTappable
//
//  Created by Mangust on 04.05.2025.
//

import XCTest
@testable import ImageTappable

class ImageDownloaderServiceTests: XCTestCase {

    let service = ImageDownloaderService()

    func testGetImages() async {
        let url = URL(string: "https://cdn2.thecatapi.com/images/se.jpg")
        let result: UIImage?

        do {
            result = try await service.downloadImage(from: url)
        } catch {
            if let urlError = error as? URLError {
                if urlError.code == .notConnectedToInternet {
                    print("No Network Connection: \(urlError.localizedDescription)")
                } else {
                    print("URLError: \(urlError.localizedDescription)")
                }
            } else {
                print("Other Error: \(error.localizedDescription)")
            }
            result = nil
        }

        XCTAssertNotNil(result)
    }
}
