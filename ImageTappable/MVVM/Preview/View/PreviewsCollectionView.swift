//
//  PreviewsCollectionView.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import SnapKit
import UIKit

final class PreviewsCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModelData: [PreviewViewModel]?) {
        self.viewModelData = viewModelData
    }

    private func setupView() {
        backgroundColor = UIColor(named: "BGColor")
        showsHorizontalScrollIndicator = false
        scrollsToTop = true

        collectionViewLayout = CustomLayout(
            interItemSpacing: Constants.offsetOuter,
            scrollDirection: .vertical,
            itemHeight: Constants.defaultItemHeight,
            groupInsets: NSDirectionalEdgeInsets(
                top: .leastNormalMagnitude,
                leading: Constants.offsetOuter,
                bottom: .leastNormalMagnitude,
                trailing: Constants.offsetOuter
            )
        )

        register(
            PreviewCell.self,
            forCellWithReuseIdentifier: String(describing: PreviewCell.self)
        )
    }

    var cellReloadCallback: ((_ url: String?, _ row: Int) -> ())?
    var viewModelData: [PreviewViewModel]?

    private var viewModel: PreviewsViewModelProtocol?
}

fileprivate extension PreviewsCollectionView {
    enum Constants {
        static let defaultItemHeight: CGFloat = 100
        static let offsetInner: CGFloat = 14
        static let offsetOuter: CGFloat = 20
    }
}
