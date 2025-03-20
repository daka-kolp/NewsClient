//
//  ArticleEntity.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 17.03.2025.
//


import Foundation
import SwiftData

@Model
class SDArticle {
    @Attribute(.unique) var url: String
    var title: String
    var source: String
    var author: String?
    var desc: String
    var urlToImage: String?
    var content: String
    var publishedAt: Date
    
    init(
        url: String,
        title: String,
        source: String,
        author: String?,
        desc: String,
        urlToImage: String?,
        content: String,
        publishedAt: Date
    ) {
        self.url = url
        self.title = title
        self.source = source
        self.author = author
        self.desc = desc
        self.urlToImage = urlToImage
        self.content = content
        self.publishedAt = publishedAt
    }
    
    init(domain: Article) {
        self.url = domain.url
        self.title = domain.title
        self.source = domain.source
        self.author = domain.author
        self.desc = domain.description
        self.urlToImage = domain.urlToImage
        self.content = domain.content
        self.publishedAt = domain.publishedAt
    }
    
    func toDomainModel() -> Article {
        return Article(
            source: source,
            author: author,
            title: title,
            description: desc,
            url: url,
            urlToImage: urlToImage,
            content: content,
            publishedAt: publishedAt
        )
    }
}
