//
//  NewsRepo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//


protocol NewsRepo {
    func fetchArticlesByQuery(query: String, page: Int) async -> Result<[Article], Error>
    
    func fetchTopArticles(category: String, page: Int) async -> Result<[Article], Error>
}

//let newsRepoInstance: NewsRepo = HTTPNewsRepo.instance
let newsRepoInstance: NewsRepo = MockNewsRepo.instance
