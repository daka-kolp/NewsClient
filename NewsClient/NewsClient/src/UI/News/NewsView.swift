//
//  NewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import AlertToast
import SwiftUI

struct NewsView: View {
    
    @StateObject private var newsViewModel = NewsViewModel()
    
    var body: some View {
        VStack{
            List {
                ForEach(Array(newsViewModel.articles.enumerated()), id: \.offset) { index, article in
                    ArticleRowView(article: article)
                }
                if newsViewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if !newsViewModel.isLoading && newsViewModel.error.isEmpty{
                    Spacer().onAppear { getArticles() }
                }
            }
        }
    }
    
    private func getArticles() {
        // Task { await newsViewModel.getArticlesByQuery(query: "Ukraine") }
        Task { await newsViewModel.getTopArticles() }
    }
}
