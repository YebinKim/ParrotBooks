//
//  UICollectionView+Extension.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

extension UICollectionView {
    
    func registerFromNib(`class`: NSObject.Type) {
        let cellNib = UINib(nibName: `class`.identifier, bundle: nil)
        self.register(cellNib, forCellWithReuseIdentifier: `class`.identifier)
    }
}
