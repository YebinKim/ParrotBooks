//
//  MockURLSession.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

final class MockURLSession {
    
    struct MockResponse {
        let data: Data?
        let urlResponse: URLResponse?
        let error: Error?
    }
    
    private let response: MockResponse
    
    init(
        response: MockResponse
    ) {
        self.response = response
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        
        let sessionDataTask = MockURLSessionDataTask(
            resumeDidCall: {
                completionHandler(self.response.data, self.response.urlResponse, self.response.error)
            },
            cancelDidCall: {
                completionHandler(nil, nil, nil)
            }
        )
        
        return sessionDataTask
    }
}

// MARK: - URLSession confirm URLSessionProtocol
protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
extension MockURLSession: URLSessionProtocol {}

// MARK: - URLSessionDataTask confirm URLSessionDataTaskProtocol
protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private let resumeDidCall: () -> Void
    private let cancelDidCall: () -> Void
    
    init(
        resumeDidCall: @escaping () -> Void,
        cancelDidCall: @escaping () -> Void
    ) {
        self.resumeDidCall = resumeDidCall
        self.cancelDidCall = cancelDidCall
    }
    
    func resume() {
        resumeDidCall()
    }
    func cancel() {
        cancelDidCall()
    }
}
