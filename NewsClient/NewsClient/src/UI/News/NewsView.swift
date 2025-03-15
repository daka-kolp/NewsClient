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
                Text("loading")
            case .loaded(let articles):
                List {
                    ForEach(articles) { article in
                        ArticleRowView(article: article)
                    }
                }
            case .error(let e):
                Text("error\(e)")
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
