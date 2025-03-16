//
//  NewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import SwiftUI

struct NewsView: View {
    
    @StateObject private var newsViewModel = NewsViewModel()
    @State private var type = 0
    
    var body: some View {
        VStack (spacing: 0) {
            Picker(selection: $type, label: Text("newsTopic")) {
                Text("all").tag(0)
                ForEach(NewsCategory.all) { newsCategory in
                    Text(LocalizedStringKey(newsCategory.localeKey)).tag(newsCategory.id)
                }
            }
            .padding(.horizontal, 16.0)
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: type) { _, __ in
                getArticles(useReset: true)
            }
            List {
                ForEach(
                    Array(newsViewModel.articles.enumerated()),
                    id: \.offset
                ) { index, article in ArticleRowView(article: article) }
                if newsViewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if !newsViewModel.isLoading && newsViewModel.error.isEmpty{
                    Spacer().onAppear {
                        getArticles()
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                getArticles(useReset: true)
            }
        }
    }
    
    private func getArticles(useReset: Bool = false) {
        Task {
            if (useReset) { newsViewModel.reset() }
            
            switch(type) {
            case 0:
                await newsViewModel.getTopArticles()
            default:
                let newsCategory = NewsCategory.all.first(where: { $0.id == type })
                guard let newsCategory else { return }
                
                await newsViewModel.getArticlesByQuery(query: newsCategory.query)
            }
        }
    }
}

private class NewsCategory: Identifiable {
    let query: String
    let localeKey: String
    let id: Int
    
    init(query: String, localeKey: String, id: Int) {
        self.query = query
        self.localeKey = localeKey
        self.id = id
    }
    
    static let all: [NewsCategory] = [
        .init(query: "sports", localeKey: "sports", id: 1),
        .init(query: "show business", localeKey: "showBusiness", id: 2),
    ]
}
