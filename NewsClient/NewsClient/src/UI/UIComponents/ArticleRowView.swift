//
//  ArticleRowView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 15.03.2025.
//


import SwiftUI

struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        HStack {
            ArticleImage
            VStack(alignment: .leading, spacing: 12.0) {
                Text(article.title)
                    .foregroundColor(.primary)
                    .font(.headline)
                Text(parseDateToString(article.publishedAt))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    @ViewBuilder
    private var ArticleImage: some View {
        if (article.urlToImage == nil) {
            NoImage()
        } else {
            UrlImage(imageUrl: article.urlToImage!)
        }
    }
}

private struct UrlImage: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            if let image = phase.image {
                image.resizable().aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                NoImage()
            } else {
                ProgressView().progressViewStyle(.circular)
            }
        }.frame(width: 80.0, height: 80.0).clipShape(.rect(cornerRadius: 4.0))
    }
}

private struct NoImage: View {
    var body: some View {
        Image("no-image").resizable().aspectRatio(contentMode: .fill)
            .frame(width: 80.0, height: 80.0)
            .clipShape(.rect(cornerRadius: 4.0))
    }
}
