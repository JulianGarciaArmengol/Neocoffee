//
//  FavoritesViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import UIKit
import Combine
import FirebaseAnalytics

fileprivate enum SectionFavorite {
    case banners
    case favorites
}

fileprivate enum Item: Hashable {
    case banner([Banner])
    case favorite(Favorite)
}

class FavoritesViewController: UIViewController {
    let viewModel: FavoritesViewModel
    
    private var dataSource: UITableViewDiffableDataSource<SectionFavorite, Item>!
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = nil
        view.estimatedRowHeight = 150.0
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        // register cells
        view.register(ImageWithTitleViewCell.self, forCellReuseIdentifier: "header")
        view.register(FavoriteViewCell.self, forCellReuseIdentifier: "cell")
        
        return view
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        viewModel: FavoritesViewModel = FavoritesViewModel()
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background")
        
        setupViews()
        setupCollectionView()
        setupBindings()
        
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getAllItems()
        
        Analytics.logEvent("favorites_open", parameters: [:])
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupCollectionView() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            
            let cell: UITableViewCell
            
            switch item {
            case .banner(_ ):
                let cellRecommended = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! ImageWithTitleViewCell
                        
                cellRecommended.imageBackgroundView.image = UIImage(named: "bn2")
                cellRecommended.titleLabel.text = "Quizas quieras probar tambien ..."
                
                cell = cellRecommended
                
            case .favorite(let favorite):
                let cellFavorite = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoriteViewCell
                
                cellFavorite.titleLabel.text = favorite.name
                cellFavorite.descriptionTextView.text = """
                                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                """
                cellFavorite.imageRoundedView.image = UIImage(named: "f1")
                cellFavorite.backgroundColor = UIColor.clear
                cellFavorite.layer.backgroundColor = UIColor.clear.cgColor
                
                cell = cellFavorite
            }
            
            return cell
        })
    }
    
    private func setupBindings() {
        viewModel.banners
            .combineLatest(viewModel.favorites)
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] (banners, favorites) in
                var items = [Item]()
                
                items.append(Item.banner(banners))
                items.append(contentsOf: favorites.map { .favorite($0) })
                
                print(items)
                self?.applySnapshot(items)
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(_ items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionFavorite, Item>()
        
        snapshot.appendSections([.banners, .favorites])
        
        items.forEach { item in
            switch item {
            case .banner(_ ):
                snapshot.appendItems([item], toSection: .banners)
            case .favorite(_ ):
                snapshot.appendItems([item], toSection: .favorites)
            }
        }
        
        dataSource.apply(snapshot)
    }
}

extension FavoritesViewController: TabBarTopControllerSubView {
    func ajustSafeArea(additionalSafeAreaInsets: UIEdgeInsets) {
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 200 : 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section > 0 else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {[weak self] _, _, completionHandler in
            
            if let _ = self?.viewModel.favorites.values {
                self?.viewModel.deleteItemAt(indexPath: indexPath)
            }
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == viewModel.favorites.value.count - 1 {
            viewModel.nextPage()
        }
    }
}
