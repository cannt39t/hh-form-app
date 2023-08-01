//
//  BaseCollectionReusableView.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    
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

@objc extension BaseCollectionReusableView {
    
    func setupViews() { }
    func constraintViews() { }
    func configureAppearance() {
        backgroundColor = R.Colors.background
    }
}
