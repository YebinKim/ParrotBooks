//
//  NSObject+Extension.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import Foundation

extension NSObject {
    
    static var identifier: String {
        String(describing: self)
    }
}
