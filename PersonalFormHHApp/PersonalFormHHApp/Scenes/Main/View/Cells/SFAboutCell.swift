//
//  SFAboutCell.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

final class SFAboutCell: BaseCollectionViewCell {
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.defaultFont(14)
        label.textColor = R.Colors.label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    func setup(with text: String) {
        textLabel.text = text
    }
}

extension SFAboutCell {
    
    override func setupViews() {
        super.setupViews()
        
        setupView(textLabel)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
