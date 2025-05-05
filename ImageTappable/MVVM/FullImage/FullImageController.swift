//
//  FullImageController.swift
//  ImageTappable
//
//  Created by Mangust on 04.05.2025.
//

import SnapKit
import UIKit

final class FullImageController: UIViewController {

    init(viewModel: FullImageViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "BGColor")

        setupNavigation()
        setupView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureConstraints()
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.closeIcon,
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
    }

    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(spinner)

        guard let url = viewModel?.imageUrl else {
            return
        }

        Task {
            await imageView.loadImage(from: url)
        }
    }

    private func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    @objc
    private func goBack() {
        if let nav = navigationController {
            nav.popViewController(animated: false)
        } else {
            dismiss(animated: false)
        }
    }

    private let viewModel: FullImageViewModel?
    private let spinner = UIActivityIndicatorView()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}

fileprivate extension FullImageController {
    enum Constants {
        static let closeIcon = UIImage(systemName: "xmark.circle")
    }
}
