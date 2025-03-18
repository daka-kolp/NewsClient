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
    @State private var task: Task<Void, Never>?
    
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
                    Text("topNews").tag(0)
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
                            Array(viewModel.articles.enumerated()),
                            id: \.offset
                        ) { index, article in
                            NavigationLink(destination: ArticleView(article: article)) {
                                ArticleRowView(article: article)
                            }
                        }
                        if viewModel.isLoading && !viewModel.articles.isEmpty {
                            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity).id(Int.random(in: 0..<1000))
                        }
                        if !viewModel.isLoading && viewModel.error.isEmpty {
                            Spacer().onAppear { getArticles() }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable { getArticles(useReset: true) }
                    
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
        task?.cancel()
        
        task = Task.detached {
            if(!query.isEmpty) {
                if (useReset) { await viewModel.reset() }
                
                await MainActor.run { newsType = -1 }
                
                await viewModel.getArticlesByQuery(query: query)
                return
            }
            
            if await (newsType == -1) { return }
            
            if (useReset) { await viewModel.reset() }
            switch await (newsType) {
            case 0:
                await viewModel.getTopArticles()
            default:
                let type = await MainActor.run { return newsType }
                
                let newsCategory = NewsCategory.all.first(where: { $0.id == type })
                guard let newsCategory else { return }
                
                await viewModel.getArticlesByQuery(query: newsCategory.query)
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

//#Preview {
//    NewsView()
//}
