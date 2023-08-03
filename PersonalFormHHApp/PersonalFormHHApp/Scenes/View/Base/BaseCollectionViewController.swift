//
//  BaseCollectionViewController.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController {
    
    override func loadView() {
        super.loadView()
        
        setupViews()
        constraintViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
    }
}

@objc extension BaseCollectionViewController {
    
    func setupViews() { }
    func constraintViews() { }
    func configureAppearance() { }
}
