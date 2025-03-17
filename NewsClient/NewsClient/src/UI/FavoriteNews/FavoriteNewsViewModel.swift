//
//  FavoriteNewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 17.03.2025.
//


import Foundation
import SwiftUI

@MainActor
class FavoriteNewsViewModel: ObservableObject {
    private let repo: NewsRepo
    
    init() {
        self.repo = newsRepoInstance
    }
    
    @Published var articles: [Article] = []
    
    func getArticles() async {
        articles = await repo.fetchFavoritesArticles()
    }
}
