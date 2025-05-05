//
//  ImageSaveService.swift
//  ImageTappableTests
//
//  Created by Mangust on 04.05.2025.
//

import XCTest
@testable import ImageTappable

class ImageSaveServiceTests: XCTestCase {

    let service = FileSaveService()
    let converter = Converter()

    func testSaveIfNotExists() {
        let address = "https://cdn2.thecatapi.com/images/se.jpg"

        guard let _ = service.getCachedFileNameIfExists(address) else {
            guard let fileURL = URL(string: address),
                  let data = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: data) else {
                return
            }

            guard let _ = service.saveIfNotExists(
                image: image,
                name: converter.getHashedValue(from: address)
            )
            else {
                return
            }

            XCTAssertNotNil(service.getCachedFileNameIfExists(address))
            return
        }

        XCTAssertNotNil(true)
    }
}
