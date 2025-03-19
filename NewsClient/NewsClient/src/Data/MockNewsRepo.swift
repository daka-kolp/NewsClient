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
        
        let languageCode = localStorage.articleLanguage
        
        return await fetchArticles(page: page) { index in
            return mockArticle(id: "\(page)\(index)_\(languageCode)", query: query)
        }
    }
    
    func fetchTopArticles(category: String, page: Int) async -> Result<[Article], Error> {
        return await fetchArticles(page: page) { index in
            return mockTopArticle(id: "\(page)\(index)", category: category)
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
    
    private func mockTopArticle(id: String, category: String) -> Article {
        return Article(
            source: "https://testnews.com",
            author: nil,
            title: "\(id) \(category) Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
            description: "",
            url: "https://testnews.com/\(category)_top_news\(id)",
            urlToImage: nil,
            content: "",
            publishedAt: Date.now
        );
    }
    
    private func mockArticle(id: String, query: String) -> Article {
        return Article(
            source: "https://testnews.com",
            author: nil,
            title: "\(id) \(query) Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
            description: "",
            url: "https://testnews.com/\(query)_news\(id)",
            urlToImage: nil,
            content: "",
            publishedAt: Date.now
        );
    }
}
