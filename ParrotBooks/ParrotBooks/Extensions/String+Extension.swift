//
//  String+Extension.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/07.
//

import Foundation

extension String {
    
    var isbn13InUrl: String? {
        guard let splited = self.split(separator: "/").last,
              let isbn13 = splited.split(separator: ".").first else {
            return nil
        }
        return String(isbn13)
    }
}
