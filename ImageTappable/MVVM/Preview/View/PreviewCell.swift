//
//  PreviewCell.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import SnapKit
import UIKit

protocol PreviewCellProtocol: AnyObject {
    func reload(_ url: String?, row: Int)
}

final class PreviewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: PreviewViewModel?, row: Int) {
        guard let viewModel = viewModel else {
            return
        }

        self.viewModel = viewModel
        self.row = row

        configureConstraints()

        Task {
            await setupData(viewModel)
        }
    }

    func addButton(with image: UIImage, action: Selector? = nil) {
        button.isHidden = false
        button.setImage(image, for: .normal)

        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
    }

    func hideButtonIfNeeded() {
        button.isHidden = true
    }

    func hasNoImage() -> Bool {
        imageView.image == nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(button)

        imageView.addSubview(spinner)
    }

    private func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(Constants.imageHeight)
            $0.edges.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.height.width.equalTo(Constants.buttonHeight)
            $0.center.equalToSuperview()
        }
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupData(_ viewModelData: PreviewViewModel) async {
        viewModel = viewModelData

        switch viewModelData.state {
        case .manualReload:
            addButton(
                with: UIImage(systemName: "gobackward")!,
                action: #selector(reload)
            )
        case .autoReload:
            addButton(
                with: UIImage(systemName: "person.circle.fill")!
            )
            reloadUrlCallback?(viewModel?.url, row)
        case .downloaded(let imageAddress):
            guard let url = URL(string: imageAddress) else {
                showSpinnerInImage()
                return
            }

            hideSpinnerInImage()
            hideButtonIfNeeded()
            await imageView.loadImage(from: url)
        case .none:
            break
        }
    }

    private func showSpinnerInImage() {
        spinner.startAnimating()
    }

    private func hideSpinnerInImage() {
        spinner.stopAnimating()
    }

    @objc
    private func reload() {
        reloadUrlCallback?(viewModel?.url, row)
    }

    var id: Int?
    var reloadUrlCallback: ((_ url: String?, _ row: Int) -> ())?

    private var viewModel: PreviewViewModel?
    private var row: Int = 0

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: "CellBGColor")

        return imageView
    }()

    private let button: UIButton = {
        let btn = UIButton()
        return btn
    }()

    private let spinner = UIActivityIndicatorView()
}

fileprivate extension PreviewCell {
    enum Constants {
        static let offsetInner: CGFloat = 0
        static let offsetOuter: CGFloat = 0
        static let imageHeight: CGFloat = 100
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 100
    }
}
