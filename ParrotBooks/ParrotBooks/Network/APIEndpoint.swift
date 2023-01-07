//
//  APIEndpoint.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

enum APIEndpoint {
    
    case search(name: String, page: Int? = nil)
    case detail(isbn13: String)
    
    static let baseUrl: String = "https://api.itbook.store/1.0/"
    
    var url: URL {
        let baseUrl: String = "\(APIEndpoint.baseUrl)\(path)"
        let encodingUrl: String = baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: encodingUrl)!
    }
    
    var method: String {
        switch self {
        case .search, .detail:
            return "GET"
        }
    }
    
    private var path: String {
        switch self {
        case .search(let name, let page):
            if let page {
                return "/search/\(name)/\(page)"
            } else {
                return "/search/\(name)"
            }
        case .detail(let isbn13):
            return "/books/\(isbn13)"
        }
    }
}

extension APIEndpoint {
    
    var mockData: Data {
        switch self {
        case .search:
            return """
            {
            "error": "0",
            "total": "78",
            "page": "1",
            "books" : [
                {
                    "title":"MongoDB in Action, 2nd Edition",
                    "subtitle":"Covers MongoDB version 3.0",
                    "isbn13":"9781617291609",
                    "price":"$19.99",
                    "image":"https://itbook.store/img/books/9781617291609.png",
                    "url":"https://itbook.store/books/9781617291609"
                },
                {
                    "title":"Practical MongoDB",
                    "subtitle":"Architecting, Developing, and Administering MongoDB",
                    "isbn13":"9781484206485",
                    "price":"$41.65",
                    "image":"https://itbook.store/img/books/9781484206485.png",
                    "url":"https://itbook.store/books/9781484206485"},
                {
                    "title":"The Definitive Guide to MongoDB, 3rd Edition",
                    "subtitle":"A complete guide to dealing with Big Data using MongoDB",
                    "isbn13":"9781484211830",
                    "price":"$49.99",
                    "image":"https://itbook.store/img/books/9781484211830.png",
                    "url":"https://itbook.store/books/9781484211830"},
                {
                    "title":"MongoDB Performance Tuning",
                    "subtitle":"Optimizing MongoDB Databases and their Applications",
                    "isbn13":"9781484268780",
                    "price":"$34.74",
                    "image":"https://itbook.store/img/books/9781484268780.png",
                    "url":"https://itbook.store/books/9781484268780"},
                {
                    "title":"Pentaho Analytics for MongoDB",
                    "subtitle":"Combine Pentaho Analytics and MongoDB to create powerful analysis and reporting solutions",
                    "isbn13":"9781782168355","price":"$16.99",
                    "image":"https://itbook.store/img/books/9781782168355.png",
                    "url":"https://itbook.store/books/9781782168355"},
                {
                    "title":"Pentaho Analytics for MongoDB Cookbook",
                    "subtitle":"Over 50 recipes to learn how to use Pentaho Analytics and MongoDB to create powerful analysis and reporting solutions",
                    "isbn13":"9781783553273","price":"$44.99",
                    "image":"https://itbook.store/img/books/9781783553273.png",
                    "url":"https://itbook.store/books/9781783553273"},
                {
                    "title":"Web Development with MongoDB and NodeJS, 2nd Edition",
                    "subtitle":"Build an interactive and full-featured web application from scratch using Node.js and MongoDB",
                    "isbn13":"9781785287527",
                    "price":"$39.99",
                    "image":"https://itbook.store/img/books/9781785287527.png",
                    "url":"https://itbook.store/books/9781785287527"},
                {
                    "title":"MongoDB Cookbook, 2nd Edition",
                    "subtitle":"Harness the latest features of MongoDB 3 with this collection of 80 recipes - from managing cloud platforms to app development, this book is a vital resource",
                    "isbn13":"9781785289989",
                    "price":"$44.99",
                    "image":"https://itbook.store/img/books/9781785289989.png",
                    "url":"https://itbook.store/books/9781785289989"},
                {
                    "title":"The Little MongoDB Book",
                    "subtitle":"",
                    "isbn13":"1001592208320",
                    "price":"$0.00",
                    "image":"https://itbook.store/img/books/1001592208320.png",
                    "url":"https://itbook.store/books/1001592208320"},
                {
                    "title":"Learning MongoDB",
                    "subtitle":"",
                    "isbn13":"1001629462276",
                    "price":"$0.00",
                    "image":"https://itbook.store/img/books/1001629462276.png",
                    "url":"https://itbook.store/books/1001629462276"}
            ]}
            """
                .data(using: .utf8)!
        case .detail:
            return """
            {
                "error":"0",
                "title":"Securing DevOps",
                "subtitle":"Security in the Cloud",
                "authors":"Julien Vehent",
                "publisher":"Manning",
                "language":"English",
                "isbn10":"1617294136",
                "isbn13":"9781617294136",
                "pages":"384",
                "year":"2018",
                "rating":"5",
                "desc":"An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team&#039;s highest priority is understanding those risks and hardening the system against them.Securing DevOps teaches you the essential techniques to secure your c...",
                "price":"$39.65",
                "image":"https://itbook.store/img/books/9781617294136.png",
                "url":"https://itbook.store/books/9781617294136",
                "pdf":{
                    "Chapter 2":"https://itbook.store/files/9781617294136/chapter2.pdf",
                    "Chapter 5":"https://itbook.store/files/9781617294136/chapter5.pdf"
                }
            }
            """
                .data(using: .utf8)!
        }
    }
}
