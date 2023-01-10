//
//  Debouncer.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/09.
//

import Foundation

actor Debouncer {
    
    private let minimumDelay: TimeInterval
    private var task: Task<Void, Never>?
    
    private var nanoseconds: UInt64 {
        UInt64(minimumDelay * 1_000_000_000)
    }
    
    init(
        minimumDelay: TimeInterval,
        task: Task<Void, Never>? = nil
    ) {
        self.minimumDelay = minimumDelay
        self.task = task
    }
    
    func debounce(action: @escaping () async -> Void) {
        self.task?.cancel()
        
        self.task = Task {
            do {
                try await Task.sleep(nanoseconds: nanoseconds)
                guard !Task.isCancelled else { return }
                await action()
            } catch {
                return
            }
        }
    }
}
