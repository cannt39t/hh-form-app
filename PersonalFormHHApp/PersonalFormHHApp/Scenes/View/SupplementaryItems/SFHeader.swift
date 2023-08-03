//
//  SFHeader.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

final class SFHeader: BaseCollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.Colors.label
        label.font = R.Fonts.defaultFont(16, .medium)
        return label
    }()
    
    private let additionalButton: UIButton = {
        let button = UIButton()
        button.setImage(R.Images.pencil, for: .normal)
        button.setImage(R.Images.checkmarkCircle, for: .selected)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    private var handler: () -> Void = { }
    
    func setup(title: String, buttonHidden: Bool, isEditing: Bool, completion: (() -> Void)? = nil) {
        if let completion {
            handler = completion
        }
        titleLabel.text = title
        additionalButton.isHidden = buttonHidden
        additionalButton.addTarget(self, action: #selector(didTapOnAdditionalButton), for: .touchUpInside)
        // refactor
        additionalButton.isSelected = isEditing
    }
    
    @objc private func didTapOnAdditionalButton() {
        handler()
    }
}

extension SFHeader {
    
    override func setupViews() {
        super.setupViews()
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(additionalButton)
        setupView(stackView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        makeSystem(additionalButton)
    }
}
