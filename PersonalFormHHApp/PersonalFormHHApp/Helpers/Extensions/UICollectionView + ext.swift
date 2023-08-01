//
//  UICollectionView + ext.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

extension UICollectionView {
    
    func register<Cell: UICollectionViewCell>(_ cellType: Cell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    func register<SupplementaryView: UICollectionReusableView>(_ supplementaryViewType: SupplementaryView.Type) {
        register(supplementaryViewType, forSupplementaryViewOfKind: supplementaryViewType.identifier, withReuseIdentifier: supplementaryViewType.identifier)
    }
    
    func getReuseCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! Cell
    }
    
    func getReuseSupplementaryView<SupplementaryView: UICollectionReusableView>(_ supplementaryViewType: SupplementaryView.Type, indexPath: IndexPath) -> SupplementaryView {
        dequeueReusableSupplementaryView(ofKind: SupplementaryView.identifier, withReuseIdentifier: SupplementaryView.identifier, for: indexPath) as! SupplementaryView
    }
}
