//
//  ArticleView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 16.03.2025.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack {
                ArticleImage(imageUrl: article.urlToImage)
                Group {
                    Text(article.title)
                    if !article.description.isEmpty {
                        Text(article.description).font(.subheadline)
                    }
                    if !article.content.isEmpty {
                        Text(article.content).font(.subheadline)
                    }
                    Button { setFavorite() } label: { Image(systemName: "heart") }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Button { launchLink() } label: { Text(article.url) }
                    HStack {
                        Text(article.author ?? "").font(.subheadline)
                        Spacer()
                        Text(parseDateToString(article.publishedAt))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.all, 4.0)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.all, 24.0)
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func setFavorite() {
        //TODO: add to Favourite/remove from Favourite
    }
    
    private func launchLink() {
        //TODO: open source link
    }
}

private struct ArticleImage: View {
    let imageUrl: String?
    
    var body: some View {
        Group {
            if (imageUrl == nil) {
                NoImage()
            } else {
                UrlImage(imageUrl: imageUrl!)
            }
        }
        .padding(.horizontal, -24.0)
        .clipShape(.rect(cornerRadius: 16.0))
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
        }
        .frame(width: 390.0, height: 190.0)
    }
}

private struct NoImage: View {
    var body: some View {
        Image("no-image")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 390.0, height: 190.0)
    }
}

//#Preview {
//    ArticleView(article: mockArticle())
//}

private func mockArticle() -> Article {
    return Article(
        source: "https://testnews.com",
        author: "John Dou",
        title: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
        description: "",
        url: "https://testnews.com/test_news",
        urlToImage: "https://free-images.com/lg/34b9/lipari_sicily_sea_nature.jpg",
        content: "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu.",
        publishedAt: Date.now
    );
}
