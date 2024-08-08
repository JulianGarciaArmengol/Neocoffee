//
//  FavoriteViewCell.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit

class FavoriteViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .white
        return view
    }()
    
    var imageRoundedView: UIImageRoundedView = {
        let view = UIImageRoundedView(image: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var descriptionTextView: UITextView = {
       let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = nil
        view.textColor = .white
        return view
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "cell-background")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViews() {
        backgroundColor = nil
        
        addSubview(container)
        addSubview(titleLabel)
        addSubview(imageRoundedView)
        addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            imageRoundedView.centerYAnchor.constraint(equalTo: descriptionTextView.centerYAnchor),
            imageRoundedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageRoundedView.widthAnchor.constraint(equalToConstant: 70.0),
            imageRoundedView.heightAnchor.constraint(equalToConstant: 70.0),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionTextView.leadingAnchor.constraint(equalTo: imageRoundedView.trailingAnchor, constant: 12),
            descriptionTextView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
        ])
    }
}
