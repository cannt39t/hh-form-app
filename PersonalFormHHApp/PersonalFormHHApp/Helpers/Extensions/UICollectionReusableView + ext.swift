//
//  UICollectionReusableView + ext.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

extension UICollectionReusableView {
    
    static var identifier: String {
        .init(describing: self)
    }
}
