//
//  UIImageWithTitleView.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit

class ImageWithTitleViewCell: UITableViewCell {
    
    let imageBackgroundView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = nil
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .black
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        
        layer.masksToBounds = true
    }
    
    
    private func setupViews() {
        addSubview(imageBackgroundView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            imageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12),
        ])
    }
}
