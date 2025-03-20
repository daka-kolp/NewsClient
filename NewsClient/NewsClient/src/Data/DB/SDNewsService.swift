//
//  SDNewsService.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 17.03.2025.
//


import Foundation
import SwiftData

@MainActor
final class SDNewsService {
    static let instance = SDNewsService()
    
    private let modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    
    private init() {
        modelContainer = try? ModelContainer(for: Schema([SDArticle.self]))
        modelContext = modelContainer?.mainContext
    }
    
    func addArticleToFavorites(_ article: Article) {
        modelContext?.insert(SDArticle(domain: article))
        try? modelContext?.save()
    }
    
    func removeArticleFromFavorites(_ article: Article) {
        guard let sdArticle = getArticleByUrl(url: article.url) else { return }
        modelContext?.delete(sdArticle)
        try? modelContext?.save()
    }
    
    func isArticleFavorite(_ article: Article) -> Bool {
        let article = getArticleByUrl(url: article.url)
        return article != nil
    }

    private func getArticleByUrl(url: String) -> SDArticle? {
        let fetchDescriptor = FetchDescriptor<SDArticle>(
            predicate: #Predicate<SDArticle> { $0.url == url }
        )
        let articles = try? modelContext?.fetch(fetchDescriptor)
        return articles?.first
    }
    
    func getFavoritesArticles() -> [Article] {
        let fetchDescriptor = FetchDescriptor<SDArticle>(
            sortBy: [SortDescriptor(\SDArticle.publishedAt)]
        )
        let articles = try? modelContext?.fetch(fetchDescriptor)
        return articles?.map { $0.toDomainModel() } ?? []
    }
    
    func clear() {
        try? modelContext?.delete(model: SDArticle.self)
    }
}
