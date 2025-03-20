//
//  NewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//


import SwiftUI

struct NewsView: View {
    
    @StateObject private var viewModel = NewsViewModel()
    @State private var newsType = 0
    @State private var searchText: String = ""
    @State private var isTaskRunning = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    TextField ("search", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 8.0, leading: 16.0, bottom: 12.0, trailing: 8.0))
                    Button { onSearch() } label: { Image(systemName: "magnifyingglass") }
                        .disabled(searchText.isEmpty)
                        .buttonStyle(.borderedProminent)
                    Button { onReload() } label: { Image(systemName: "arrow.clockwise") }
                        .buttonStyle(.borderedProminent)
                    Spacer().frame(width: 16.0)
                }
                
                Picker(selection: $newsType, label: Text("newsTopic")) {
                    ForEach(NewsCategory.all) { newsCategory in
                        Text(LocalizedStringKey(newsCategory.category)).tag(newsCategory.id)
                    }
                }
                .padding(.horizontal, 16.0)
                .pickerStyle(.segmented)
                .onChange(of: newsType) { _, newTag in onTagChanged(newTag) }
                .disabled(isTaskRunning)
                
                ZStack {
                    List {
                        ForEach(
                            Array(viewModel.articles.enumerated()),
                            id: \.offset
                        ) { index, article in
                            NavigationLink(destination: ArticleView(article: article)) {
                                ArticleRowView(article: article)
                            }
                        }
                        if viewModel.isLoading && !viewModel.articles.isEmpty {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .id(Int.random(in: 0..<1000))
                        }
                        if !viewModel.isLoading && viewModel.error.isEmpty {
                            Spacer().onAppear { getArticles() }
                        }
                    }
                    .listStyle(.plain)
                    
                    if viewModel.articles.isEmpty {
                        if viewModel.isLoading {
                            Text("loading")
                        } else {
                            Text("noArticles")
                        }
                    }
                }
            }
        }
    }
    
    private func onSearch() {
        if (!searchText.isEmpty) {
            newsType = -1
            getArticlesByQuery(useReset: true)
        }
    }
    
    private func onReload() {
        searchText = ""
        newsType = 0
    }
    
    private func onTagChanged(_ tag: Int) {
        if (tag == -1) { return }
        searchText = ""
        getTopArticles(useReset: true)
    }
    
    private func getArticles() {
        if (newsType == -1) {
            getArticlesByQuery()
        } else {
            getTopArticles()
        }
    }
    
    private func getArticlesByQuery(useReset: Bool = false) {
        if (isTaskRunning) { return }
        
        Task {
            if(!searchText.isEmpty) {
                await MainActor.run { isTaskRunning = true }
                
                if (useReset) { viewModel.reset() }
                await viewModel.getArticlesByQuery(query: searchText)
                
                await MainActor.run { isTaskRunning = false }
            }
        }
    }
    
    private func getTopArticles(useReset: Bool = false) {
        if (isTaskRunning) { return }
        
        Task {
            await MainActor.run { isTaskRunning = true }
            
            if (useReset) { viewModel.reset() }
            let type = await MainActor.run { return newsType}
            let category = NewsCategory.all.first(where: { $0.id == type })?.category ?? ""
            await viewModel.getTopArticles(category: category)
            
            await MainActor.run { isTaskRunning = false }
        }
    }
}

private class NewsCategory: Identifiable {
    let category: String
    let id: Int
    
    init(category: String, id: Int) {
        self.category = category
        self.id = id
    }
    
    static let all: [NewsCategory] = [
        .init(category: "general", id: 0),
        .init(category: "entertainment", id: 1),
        .init(category: "science", id: 2),
        .init(category: "technology", id: 3),
//        .init(category: "business", id: 4),
//        .init(category: "health", id: 5),
//        .init(category: "sports", id: 6),
    ]
}

//#Preview {
//    NewsView()
//}
