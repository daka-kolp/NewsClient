//
//  NewsRepo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

protocol NewsRepo {
    func fetchArticles(query: String) async -> Result<[Article], Error>
}
