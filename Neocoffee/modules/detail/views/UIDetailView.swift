//
//  UIDetailView.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit

class UIDetailView: UIView {
    
    var labelTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .white
        view.numberOfLines = 1
        return view
    }()
    
    var textViewDescription: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = nil
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    var buttonLike: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    var buttonShare: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(labelTitle)
        addSubview(textViewDescription)
        addSubview(buttonShare)
        addSubview(buttonLike)
        
        NSLayoutConstraint.activate([
            // icons
            buttonShare.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            buttonShare.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            buttonShare.widthAnchor.constraint(equalToConstant: 20),
            buttonShare.heightAnchor.constraint(equalToConstant: 20),
            
            buttonLike.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            buttonLike.trailingAnchor.constraint(equalTo: buttonShare.leadingAnchor, constant: -12),
            buttonLike.widthAnchor.constraint(equalToConstant: 20),
            buttonLike.heightAnchor.constraint(equalToConstant: 20),
            
            // title
            labelTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            labelTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            labelTitle.trailingAnchor.constraint(equalTo: buttonLike.leadingAnchor, constant: -12),
            
            // description
            textViewDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 12),
            textViewDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            textViewDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textViewDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
}
