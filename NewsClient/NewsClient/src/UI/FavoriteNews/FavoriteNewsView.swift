//
//  FavoriteNewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 15.03.2025.
//


import SwiftUI

struct FavoriteNewsView: View {
    @StateObject private var viewModel = FavoriteNewsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(Array(viewModel.articles)) { article in
                        NavigationLink(destination: ArticleView(article: article)) {
                            ArticleRowView(article: article)
                        }
                    }
                }
                .listStyle(.plain)
                .onAppear { getArticles() }

                if viewModel.articles.isEmpty {
                    Text("noFavoriteArticles")
                }
            }
            .navigationBarTitle(Text("favoriteNews"))
        }
    }
    
    private func getArticles() {
        Task { await viewModel.getArticles() }
    }
}
