//
//  SFSkillCell.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

final class SFSkillCell: BaseCollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = R.Colors.label
        label.font = R.Fonts.defaultFont(14)
        label.numberOfLines = 1
        return label
    }()
    
    private let deleteButton: SFBiggerButton = {
        let button = SFBiggerButton(increasePX: 8)
        button.setImage(R.Images.cancel, for: .normal)
        return button
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        return stack
    }()
    
    private var handler: () -> Void = {}
    
    func setup(text: String, isEditing: Bool, completion: @escaping () -> Void) {
        handler = completion
        nameLabel.text = text
        deleteButton.isHidden = !isEditing
        deleteButton.addTarget(self, action: #selector(didTapOnDeleteButton), for: .touchUpInside)
        layoutIfNeeded()
    }
    
    @objc func didTapOnDeleteButton() {
        handler()
    }
}

extension SFSkillCell {
    
    override func setupViews() {
        super.setupViews()
        
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(deleteButton)
        
        setupView(stack)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 14),
            deleteButton.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = R.Colors.secondaryBackground
        backgroundView = lightView
        
        let selectedView = UIView(frame: bounds)
        selectedView.backgroundColor = R.Colors.secondaryLabel
        selectedBackgroundView = selectedView
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}
