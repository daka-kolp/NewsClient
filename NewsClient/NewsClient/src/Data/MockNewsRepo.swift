//
//  NewsRepo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 16.03.2025.
//


import Foundation

class MockNewsRepo: NewsRepo {
    static let instance = MockNewsRepo()
    
    private let localStorage: LocalStorageService
    private let pageSize = 10
    
    private init() {
        self.localStorage = LocalStorageService.instance
    }
    
    func fetchArticlesByQuery(query: String, page: Int) async -> Result<[Article], Error> {
        if (query.lowercased() == "test") {
            return .success([])
        }
        
        let region = localStorage.region
        
        return await fetchArticles(page: page) { index in
            return mockArticle(id: "\(page)\(index)_\(region.languageCode)", theme: query)
        }
    }
    
    func fetchTopArticles(page: Int) async -> Result<[Article], Error> {
        let region = localStorage.region
        
        return await fetchArticles(page: page) { index in
            return mockTopArticle(id: "\(page)\(index)_\(region.regionCode)")
        }
    }
    
    private func fetchArticles(page: Int, generateArticle: (_ index: Int) -> Article) async -> Result<[Article], Error> {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {
            return .failure(NSError(domain: "Task Sleep Error",  code: -1, userInfo: nil))
        }
        
        if (page > 3) {
            return .failure(NSError(domain: "No Articles",  code: -1, userInfo: nil))
        }
        
        let articles = (0 ..< pageSize).map{ index in generateArticle(index) }
        return .success(articles)
    }
    
    private func mockTopArticle(id: String) -> Article {
        return Article(
            source: "https://testnews.com",
            author: nil,
            title: "\(id) Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
            description: "",
            url: "https://testnews.com/top_news",
            urlToImage: nil,
            content: "",
            publishedAt: Date.now
        );
    }
    
    private func mockArticle(id: String, theme: String) -> Article {
        return Article(
            source: "https://testnews.com",
            author: nil,
            title: "\(id) \(theme) Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
            description: "",
            url: "https://testnews.com/\(theme)_news",
            urlToImage: nil,
            content: "",
            publishedAt: Date.now
        );
    }
}
