//
//  FeatureDetailViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class FeatureDetailViewController: UIViewController {
    
    private let dessert: Dessert
    
    private let favoritesStore: FavoritesStore
    
    private var isLiked = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var detailView: UIDetailView = {
        let view = UIDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "box-background")
        return view
    }()
    
    init(
        dessert: Dessert,
        favoritesStore: FavoritesStore = FavoritesStore()
    ) {
        self.dessert = dessert
        self.favoritesStore = favoritesStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        setupDetails()
        setupActions()
        setupBindings()
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(detailView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            detailView.heightAnchor.constraint(equalToConstant: 164),
        ])
    }
    
    private func setupDetails() {
        let urlString = "https://eniadesign.com.mx"
        let url = URL(string: urlString)!.appendingPathComponent(dessert.image)
        
        imageView.downloadedFrom(url: url, contentMode: .scaleAspectFill)
        
        detailView.labelTitle.text = dessert.name
        detailView.textViewDescription.text = dessert.description
        
        detailView.buttonShare.setImage(
            UIImage(systemName: "square.and.arrow.up")!,
            for: .normal
        )
        detailView.buttonLike.setImage(
            UIImage(systemName: "heart.fill")!,
            for: .normal
        )
    }
    
    private func setupBindings() {
        favoritesStore.favorites
            .sink {[weak self] result in
                switch result {
                case .success(_ ):
                    print("favorite added")
                    
                    // Log analytics event
                    guard let self else { return }
            
                    Analytics.logEvent("favorite_added", parameters: [
                        "id": self.dessert.id as NSObject,
                        "cake_name": self.dessert.name as NSObject,
                        "cake_description": self.dessert.description as NSObject,
                    ])
                case .failure(let error):
                    print(error)
                }
            }.store(in: &cancellables)
    }
    
    private func setupActions() {
        let likeAction = UIAction {[unowned self] _ in
            guard let user = UserStore.shared.currentUser else { return }
            
            isLiked.toggle()
            
            detailView.buttonLike.tintColor = isLiked ? .red : .lightGray
            
            favoritesStore.saveFavorite(email: user.mail, dessert: dessert)
        }
        
        detailView.buttonLike.addAction(likeAction, for: .touchUpInside)
    }
}
