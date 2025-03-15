//
//  NewsRepo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

protocol NewsRepo {
    func fetchArticlesByQuery(query: String) async -> Result<[Article], Error>
}
