//
//  NewsViewModel.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//


import Foundation
import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    private let repo: NewsRepo
    
    init() {
        self.repo = newsRepoInstance
    }
    
    @Published var newsState = NewsState()
    private var page = 1
    
    func getTopArticles() async {
        await getArticles {
            return await repo.fetchTopArticles(page: page)
        }
    }
    
    func getArticlesByQuery(query: String) async {
        await getArticles {
            return await repo.fetchArticlesByQuery(query: query, page: page)
        }
    }
    
    func reset() {
        newsState = NewsState()
        page = 1
    }
    
    private func getArticles(fetchArticles: () async -> Result<[Article], Error>) async {
        let uniqueId = Int.random(in: 0..<1000)
        print("getArticles start \(uniqueId)")
        
        newsState = newsState.copyWith(isLoading: true, error: "")
        
        let result = await fetchArticles()
        
        switch result {
        case .success (let articles):
            let allArticles = newsState.articles + articles
            newsState = newsState.copyWith(articles: allArticles)
            page += 1
        case .failure (let error):
            newsState = newsState.copyWith(error: error.localizedDescription)
        }
        
        newsState = newsState.copyWith(isLoading: false)
        
        print("getArticles end \(uniqueId)")
    }
}

class NewsState {
    var articles: [Article]
    let isLoading: Bool
    let error: String
    
    init(articles: [Article], isLoading: Bool, error: String) {
        self.articles = articles
        self.isLoading = isLoading
        self.error = error
    }
    
    init() {
        self.articles = []
        self.isLoading = false
        self.error = ""
    }
    
    func copyWith(articles: [Article]? = nil, isLoading: Bool? = nil, error: String? = nil) -> NewsState {
        return NewsState(
            articles: articles ?? self.articles,
            isLoading: isLoading ?? self.isLoading,
            error: error ?? self.error
        )
    }
}

extension NewsViewModel {
    var articles: [Article] {
        get { return newsState.articles }
    }
    
    var isLoading: Bool {
        get { return newsState.isLoading }
    }
    
    var error: String {
        get { return newsState.error }
    }
}
