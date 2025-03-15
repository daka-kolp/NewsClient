//
//  NewsRepo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 16.03.2025.
//

import Foundation

class MockNewsRepo: NewsRepo {
    private let pageSize = 10

    func fetchArticlesByQuery(query: String, page: Int) async -> Result<[Article], Error> {
        return fetchArticles(page: page)
    }
    
    func fetchTopArticles(countryCode: String, page: Int) async -> Result<[Article], Error> {
        return fetchArticles(page: page)
    }
    
    private func fetchArticles(page: Int) -> Result<[Article], Error> {
        if (page == 3) { return .failure(NSError(domain: "No Articles",  code: -1, userInfo: nil))}
        
        let articles = [Article](repeating: Article(), count: pageSize)
        return .success(articles)
    }
}

extension Article {
    init() {
        self.source = "https://testnews.com"
        self.author = nil
        self.title = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        self.description = nil
        self.url = "https://testnews.com/news/1"
        self.urlToImage = "https://w0.peakpx.com/wallpaper/211/1022/HD-wallpaper-symbol-of-love-affection-art-best-mobile-mushroom-rain-sun-sunset-tree.jpg"
        self.content = ""
        self.publishedAt = Date.now
    }
}
