//
//  NetworkTest.swift
//  NetworkTest
//
//  Created by vivi on 2023/01/05.
//

import XCTest
@testable import ParrotBooks

final class NetworkTest: XCTestCase {
    
    var sut: SessionManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_search_mongodb_success() {
        // given
        let searchedText: String = "mongodb"
        let endpoint: APIEndpoint = .search(name: searchedText)
        let urlResponse = HTTPURLResponse(
            url: endpoint.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let mockResponse = MockURLSession.MockResponse(data: endpoint.mockData, urlResponse: urlResponse, error: nil)
        let mockSession = MockURLSession(response: mockResponse)
        sut = SessionManager(session: mockSession)
        
        // when
        var result: SearchedBook?
        sut.searchBook(name: searchedText) { response in
            if let searchedBook = try? response.result.get() {
                result = searchedBook
            }
        }
        
        // then
        let expectedCount: Int = 10
        XCTAssertNotNil(result)
        XCTAssertEqual(expectedCount, result?.books.count)
    }
}
