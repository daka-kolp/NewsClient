//
//  NewsViewModel.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import Foundation

enum NewsState {
    case initial
    case loading
    case loaded([Article])
    case error(String)
}

@MainActor
class NewsViewModel: ObservableObject {
    private let repo: NewsRepo
    
    init(repo: NewsRepo = HTTPNewsRepo()) {
        self.repo = repo
    }
    
    @Published var state: NewsState = .initial
    
    func getArticles() async {
        self.state = .loading
        
        let result = await repo.fetchArticles(query: "Ukraine")
        
        switch result {
        case .success (let articles):
            self.state = .loaded(articles)
        case .failure (let error):
            self.state = .error(error.localizedDescription)
        }
    }
}
