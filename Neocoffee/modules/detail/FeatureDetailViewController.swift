//
//  FeatureDetailViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit
import FirebaseAnalytics

class FeatureDetailViewController: UIViewController {
    var feature: Features
    var dataStore: DataStore = DataStore.shared

    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var detailView: UIDetailView = {
        let view = UIDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "box-background")
        return view
    }()
    
    init(feature: Features) {
        self.feature = feature
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
        imageView.image = UIImage(named: feature.image)
        
        detailView.labelTitle.text = "Lorem ipsum"
        detailView.buttonShare.setImage(
            UIImage(systemName: "square.and.arrow.up")!,
            for: .normal
        )
        detailView.buttonLike.setImage(
            UIImage(systemName: "heart.fill")!,
            for: .normal
        )
        
        detailView.textViewDescription.text = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        """
    }
    
    private func setupActions() {
        let likeAction = UIAction {[unowned self] _ in
            self.dataStore.SaveItem(Item.sectionFeatures(self.feature))
            
            Analytics.logEvent("favorite_added", parameters: [
                "id": feature.id as NSObject,
                "url": feature.url as NSObject,
                "cake_name": "Lorem ipsum" as NSObject,
                "cake_description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." as NSObject,
            ])
        }
        
        detailView.buttonLike.addAction(likeAction, for: .touchUpInside)
    }
}
