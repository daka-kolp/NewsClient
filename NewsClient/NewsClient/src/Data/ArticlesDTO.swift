//
//  ArticlesDTO.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import Foundation

struct ArticlesDTO: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

struct ArticleDTO: Decodable {
    let source: SourceDTO
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let content: String
    
    func toDomainModel() -> Article {
        return Article(
            source: source.name,
            author: author ?? "",
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            content: content
        )
    }
}

struct SourceDTO: Decodable {
    let id: String?
    let name: String
}
