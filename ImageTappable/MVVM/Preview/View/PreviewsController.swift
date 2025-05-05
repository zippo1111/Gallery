//
//  PreviewsController.swift
//  ImageTappable
//
//  Created by Mangust on 03.05.2025.
//

import SnapKit
import UIKit

final class PreviewsController: UIViewController {

    init(viewModel: PreviewsViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        view.backgroundColor = UIColor(named: "BGColor")
        loadData()
        setupView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureConstraints()
    }

    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(spinner)
    }

    private func setupCollection() {
        guard let viewModelData = collectionView.viewModelData else {
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, PreviewViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModelData, toSection: .main)

        dataSource = UICollectionViewDiffableDataSource<Section, PreviewViewModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

            guard let cell = (collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PreviewCell.self),
                for: indexPath
            ) as? PreviewCell) else {
                return UICollectionViewCell()
            }

            cell.configure(viewModel: item, row: indexPath.row)

            cell.reloadUrlCallback = { [weak self] url, row in
                guard let url = url else {
                    return
                }

                Task {
                    guard let data = await self?.viewModel?.reloadImage(with: url)
                    else {
                        return
                    }

                    cell.configure(viewModel: data, row: indexPath.row)
                }
            }

            return cell
        })

        dataSource.applySnapshotUsingReloadData(snapshot)
    }

    private func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func loadData() {
        spinner.startAnimating()

        Task {
            guard let data = await viewModel?.fetchImages() else {
                return
            }

            viewModelData = data
        }
    }

    private func refreshCollection() {
        collectionView.configure(
            viewModelData: viewModelData
        )

        setupCollection()

        if spinner.isAnimating {
            spinner.stopAnimating()
        }
    }

    private var viewModelData: [PreviewViewModel]? {
        didSet {
            refreshCollection()
        }
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, PreviewViewModel>!
    private let viewModel: PreviewsViewModel?
    private let collectionView = PreviewsCollectionView()
    private let spinner = UIActivityIndicatorView()
}

extension PreviewsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlAddress = viewModelData?[indexPath.row].url,
              let url = URL(string: urlAddress) else {
            return
        }
        
        let fullViewModel = FullImageViewModel(imageUrl: url)
        let detailViewController = FullImageController(viewModel: fullViewModel)

        if let nav = navigationController {
            nav.pushViewController(detailViewController, animated: true)
        } else {
            present(detailViewController, animated: true, completion: nil)
        }
    }
}
