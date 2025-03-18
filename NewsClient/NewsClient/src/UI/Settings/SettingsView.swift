//
//  FavoriteNewsView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 15.03.2025.
//


import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("articlesLanguage", selection: $viewModel.articleLanguage) {
                    ForEach(viewModel.languages, id: \.self) {
                        Text(LocalizedStringKey($0))
                    }
                }
                .onChange(of: viewModel.articleLanguage) { _, newValue in
                    onArticleLanguageChanged(newValue)
                }
                
                Button ("clearCache") { clearCache() }
            }
            .navigationTitle("settings")
        }
    }
    
    func onArticleLanguageChanged(_ language: String) {
        viewModel.changeArticleLanguage(language)
    }
    
    func clearCache() {
        Task { await viewModel.clearCache() }
    }
}

//#Preview {
//    SettingsView()
//}
