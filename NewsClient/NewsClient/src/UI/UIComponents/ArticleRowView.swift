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
            ArticleImage(imageUrl: article.urlToImage)
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
}

private struct ArticleImage: View {
    let imageUrl: String?
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl ?? "no-image")) { phase in
            if let image = phase.image {
                image.resizable().aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                Image("no-image").resizable().aspectRatio(contentMode: .fill)
            } else {
                ProgressView().progressViewStyle(.circular)
            }
        }
        .frame(width: 80.0, height: 80.0)
        .clipShape(.rect(cornerRadius: 4.0))
    }
}
