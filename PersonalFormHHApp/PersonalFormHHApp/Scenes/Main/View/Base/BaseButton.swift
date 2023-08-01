//
//  BaseButton.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

class BaseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension BaseButton {
    
    func setupViews() { }
    func constraintViews() { }
    func configureAppearance() { }
}
