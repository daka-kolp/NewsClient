//
//  ArticleViewModel.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 17.03.2025.
//


import Foundation
import SwiftUI

@MainActor
class ArticleViewModel: ObservableObject {
    private let repo: NewsRepo
    
    init() {
        self.repo = newsRepoInstance
    }
    
    @Published var isFavorite: Bool = false
    
    func checkIsFavorite(_ article: Article) async {
        isFavorite = await repo.isArticleFavorite(article: article)
    }
    
    func setFavorite(_ article: Article) async {
        await repo.setFavoriteArticle(article: article)
        await checkIsFavorite(article)
    }
}
