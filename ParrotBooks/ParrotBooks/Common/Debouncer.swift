//
//  Debouncer.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/09.
//

import Foundation

final class Debouncer {
    
    private let minimumDelay: TimeInterval
    private let queue: DispatchQueue
    
    private var workItem = DispatchWorkItem(block: {})
    
    init(
        minimumDelay: TimeInterval,
        queue: DispatchQueue = .global()
    ) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }
    
    func debounce(action: @escaping (() -> Void)) {
        workItem.cancel()
        workItem = DispatchWorkItem(block: { action() })
        queue.asyncAfter(deadline: .now() + minimumDelay, execute: workItem)
    }
}
