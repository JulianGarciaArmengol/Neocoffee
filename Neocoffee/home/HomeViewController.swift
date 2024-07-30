//
//  ViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex,
            _ in
            
            let itemWidth: NSCollectionLayoutDimension
            let itemHeight: NSCollectionLayoutDimension
            
            let groupWidth: NSCollectionLayoutDimension
            let groupHeight: NSCollectionLayoutDimension
            
            switch Section.getByIndex(sectionIndex) {
            case .banner:
                groupWidth = .fractionalWidth(1)
                groupHeight = .fractionalHeight(0.2)
                itemWidth = .fractionalWidth(1)
                itemHeight = .fractionalHeight(1)
            case .features:
                groupWidth = .fractionalWidth(1)
                groupHeight = .fractionalHeight(0.5)
                itemWidth = .absolute(113)
                itemHeight = .absolute(113)
            case .recommended:
                groupWidth = .fractionalWidth(1)
                groupHeight = .fractionalHeight(0.1)
                itemWidth = .fractionalWidth(1)
                itemHeight = .fractionalHeight(1)
            }
            
            let inset = 0.0
            
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: itemWidth,
                heightDimension: itemHeight
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: inset,
                leading: inset,
                bottom: inset,
                trailing: inset
            )
            
            // Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: groupWidth,
                heightDimension: groupHeight
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: inset,
                leading: inset,
                bottom: inset,
                trailing: inset
            )
            
            return section
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        // TODO: Register cells
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        
        setupViews()
        setupCollectionView()
        setupBindings()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupBindings() {
        viewModel.data
            .compactMap { $0 }
            .sink {[weak self] res in
                self?.applySnapshot(res)
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            
            // TODO: Make custom cells
            
            // hacer que el banner sea una vista
            // hacer que el recomendado sea otra vista y personalizar el layout.
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            
            switch item {
            case .sectionBanner(let banners):
                print(banners)
                cell.backgroundColor = .red
            case .sectionFeatures(let features):
                print(features)
                cell.backgroundColor = .cyan
            case .sectionRecommended(let recommended):
                print(recommended)
                cell.backgroundColor = .blue
            }
            
            return cell
        })
    }
    
    private func applySnapshot(_ elements: Response) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([elements.bannerItems], toSection: .banner)
        snapshot.appendItems([elements.featureItems], toSection: .features)
        snapshot.appendItems([elements.recommendedItems], toSection: .recommended)
        
        dataSource.apply(snapshot)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: TabBarTopControllerSubView {
    func ajustSafeArea(additionalSafeAreaInsets: UIEdgeInsets) {
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}
