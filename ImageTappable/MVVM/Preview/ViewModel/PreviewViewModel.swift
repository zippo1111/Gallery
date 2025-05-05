//
//  PreviewViewModel.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import UIKit

struct PreviewViewModel: Hashable {
    let id = UUID()
    let url: String?
    let state: PreviewsModel.PreviewState?
}
