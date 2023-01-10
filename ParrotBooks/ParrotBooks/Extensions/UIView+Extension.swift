//
//  UIView+Extension.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/09.
//

import UIKit

extension UIView {
    
    func intiateHidden(_ hidden: Bool) {
        if hidden {
            self.alpha = 0.0
            self.isHidden = true
        } else {
            self.alpha = 1.0
            self.isHidden = false
        }
    }
}
