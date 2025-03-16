//
//  NewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import SwiftUI

struct NewsView: View {
    
    @StateObject private var newsViewModel = NewsViewModel()
    @State private var newsType = 0
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField ("search", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button { onSearch() } label: { Image(systemName: "magnifyingglass") }
                    .disabled(searchText.isEmpty)
                Button { onReload() } label: { Image(systemName: "arrow.clockwise") }
                    .padding(.horizontal, 16.0)
            }
            
            Picker(selection: $newsType, label: Text("newsTopic")) {
                Text("all").tag(0)
                ForEach(NewsCategory.all) { newsCategory in
                    Text(LocalizedStringKey(newsCategory.localeKey)).tag(newsCategory.id)
                }
            }
            .padding(.horizontal, 16.0)
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: newsType) { _, newTag in onTagChanged(newTag) }
            
            ZStack {
                List {
                    ForEach(
                        Array(newsViewModel.articles.enumerated()),
                        id: \.offset
                    ) { index, article in ArticleRowView(article: article) }
                    if newsViewModel.isLoading && !newsViewModel.articles.isEmpty {
                        ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity).id(Int.random(in: 0..<1000))
                    }
                    if !newsViewModel.isLoading && newsViewModel.error.isEmpty {
                        Spacer().onAppear { getArticles() }
                    }
                }
                .listStyle(.plain)
                .refreshable { getArticles(useReset: true) }
                
                if newsViewModel.articles.isEmpty {
                    if newsViewModel.isLoading {
                        Text("loading")
                    } else {
                        Text("noArticles")
                    }
                }
            }
        }
    }
    
    private func onSearch() {
        if (!searchText.isEmpty) {
            getArticles(useReset: true, query: searchText)
        }
    }
    
    private func onReload() {
        searchText = ""
        newsType = 0
    }
    
    private func onTagChanged(_ tag: Int) {
        if (tag == -1) { return }
        
        searchText = ""
        getArticles(useReset: true)
    }
    
    private func getArticles(useReset: Bool = false, query: String = "") {
        Task {
            if(!query.isEmpty) {
                if (useReset) { newsViewModel.reset() }
                newsType = -1
                await newsViewModel.getArticlesByQuery(query: query)
                return
            }
            
            if (newsType == -1) { return }
            
            if (useReset) { newsViewModel.reset() }
            switch(newsType) {
            case 0:
                await newsViewModel.getTopArticles()
            default:
                let newsCategory = NewsCategory.all.first(where: { $0.id == newsType })
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
