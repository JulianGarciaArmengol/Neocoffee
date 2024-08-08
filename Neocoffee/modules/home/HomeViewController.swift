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
    
    private var currentPage: Int = 1

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private lazy var paginationManager: HorizontalPaginationManager = {
        let manager = HorizontalPaginationManager(scrollView: self.collectionView)
        manager.delegate = self
        return manager
    }()

    private var cancellables = Set<AnyCancellable>()

    // Views
    private let bannerView: UIImageWithTimer = {
        let view = UIImageWithTimer(image: nil, timeInterval: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 32
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        // TODO: Register cells
        collectionView.register(RoundedImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        collectionView.backgroundColor = nil
        
        return collectionView
    }()
    
    private let recommendedView: UIImageWithTimer = {
        let view = UIImageWithTimer(image: nil, timeInterval: 7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonMap: UIButton = {
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "map-icon")!.resizedImage(
            Size: CGSize(
                width: 50.0,
                height: 50.0
            )
        )
        configuration.imagePadding = 12.0
        
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = UIColor(named: "button-background")
        configuration.contentInsets = .zero
        
        let view = UIButton(configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "border")!.cgColor
        view.layer.cornerRadius = 34
        view.setTitleColor(UIColor(named: "text-1"), for: .normal)
        view.setTitle("Ven y visítanos", for: .normal)
        return view
    }()
    
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
        
        view.backgroundColor = UIColor(named: "background")
        
        collectionView.delegate = self
        
        setupViews()
        setupCollectionView()
        setupPagination()
        setupBindings()
        
        buttonMap.addAction(UIAction(handler: { _ in
            let vc = MapViewController()
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
            
        }), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(bannerView)
        view.addSubview(collectionView)
        view.addSubview(recommendedView)
        view.addSubview(buttonMap)
        
        NSLayoutConstraint.activate([
            // banner
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 230.0),
            
            // map button
            buttonMap.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonMap.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            buttonMap.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            buttonMap.heightAnchor.constraint(equalToConstant: 68),
            
            // recommended
            recommendedView.bottomAnchor.constraint(equalTo: buttonMap.topAnchor, constant: -12),
            recommendedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recommendedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recommendedView.heightAnchor.constraint(equalToConstant: 110.0),
            
            // features
            collectionView.topAnchor.constraint(equalTo: bannerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: recommendedView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RoundedImageCollectionViewCell
            
            switch item {
            case .sectionBanner(let banners):
                print(banners)
                cell.backgroundColor = .red
            case .sectionFeatures(let features):
                cell.imageView.image = UIImage(named: features.image)
            case .sectionRecommended(let recommended):
                print(recommended)
                cell.backgroundColor = .blue
            }
            
            return cell
        })
    }
    
    
    private func setupBindings() {
        viewModel.data
            .compactMap { $0 }
            .sink {[weak self] res in
                
                // banner
                if ((self?.bannerView.images) == nil) {
                    self?.bannerView.images = res.banners.map {
                        UIImage(named: $0.image)!
                    }
                }
                
                // recommended
                if ((self?.recommendedView.images) == nil) {
                    self?.recommendedView.images = res.recommended.map {
                        UIImage(named: $0.image)!
                    }
                }
                
                // snapshot for features
                self?.applySnapshot(res)
            }
            .store(in: &cancellables)
        
        viewModel.selectedFeature
        
            .compactMap { $0 }
            .sink {[weak self] feature in
                // present detail
                
                self?.present(FeatureDetailViewController(feature: feature), animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(_ elements: Response) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([Section.features])
        snapshot.appendItems(elements.featureItems, toSection: .features)
        
        dataSource.apply(snapshot)
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectFeatureAt(indexPath)
    }
}

extension HomeViewController: HorizontalPaginationManagerDelegate {
    
    private func setupPagination() {
        self.paginationManager.refreshViewColor = .clear
        self.paginationManager.loaderColor = .white
    }
    
    private func fetchItems() {
        self.paginationManager.initialLoad()
    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        print("refresh all")
        delay(2.0) {
            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        print("load more")
        delay(2.0) { [weak self] in
            guard let self else { return }
            
            viewModel.getFeatures(page: self.currentPage)
            self.currentPage += 1
            
            completion(true)
        }
    }
}

extension HomeViewController: TabBarTopControllerSubView {
    func ajustSafeArea(additionalSafeAreaInsets: UIEdgeInsets) {
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}
