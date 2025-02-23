//
//  Article.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import Foundation

struct Article: Identifiable {
    let id = UUID()
    let source: String
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let content: String
}
