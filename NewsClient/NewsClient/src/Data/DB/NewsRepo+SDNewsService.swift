//
//  SDNewsService.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 17.03.2025.
//


import Foundation
import SwiftData

extension NewsRepo {
    func fetchFavoritesArticles() async -> [Article] {
        let sdNewsService = await SDNewsService.instance
        return await sdNewsService.getFavoritesArticles()
    }
    
    func setFavoriteArticle(article: Article) async {
        let sdNewsService = await SDNewsService.instance
        let isFavorite = await sdNewsService.isArticleFavorite(article)
        
        if isFavorite {
            await sdNewsService.removeArticleFromFavorites(article)
        } else {
            await sdNewsService.addArticleToFavorites(article)
        }
    }
    
    func isArticleFavorite(article: Article) async -> Bool {
        let sdNewsService = await SDNewsService.instance
        return await sdNewsService.isArticleFavorite(article)
    }
}
