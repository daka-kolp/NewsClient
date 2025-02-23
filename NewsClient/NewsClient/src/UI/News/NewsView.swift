//
//  NewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import SwiftUI

struct NewsView: View {
    
    @StateObject private var newsViewModel = NewsViewModel()
    
    var body: some View {
        VStack{
            switch(newsViewModel.state) {
            case .loading:
                Text("Loading...")
            case .loaded(let articles):
                List {
                    ForEach(articles) { article in
                        ArticleRowView(article: article)
                    }
                }
            case .error(let e):
                Text("\(e)")
            default:
                Spacer()
            }
        }
        .onAppear() { getArticles() }
    }
    
    private func getArticles() {
        Task { await newsViewModel.getArticles() }
    }
}

struct ArticleRowView: View {
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .foregroundColor(.primary)
                .font(.headline)
            Text(article.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
