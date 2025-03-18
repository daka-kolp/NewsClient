//
//  SettingsViewModel.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 17.03.2025.
//


import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    private let repo: NewsRepo
    private let localStorage: LocalStorageService
    
    init() {
        self.repo = newsRepoInstance
        self.localStorage = LocalStorageService.instance
        initProperties()
    }
    
    @Published var articleLanguage = defaultLanguage
    
    let languages: [String] = languagesDictionary.keys.map { $0 }
    
    private func initProperties() {
        let languageCode = localStorage.articleLanguage
        articleLanguage = languagesDictionary.first(where: { $0.value == languageCode })?.key ?? defaultLanguage
    }

    func changeArticleLanguage(_ language: String) {
        let languageCode = languagesDictionary.first(where: { $0.key == language })?.value ?? defaultLanguageCode
        localStorage.articleLanguage = languageCode
    }
    
    func clearCache() async {
        await repo.clearSD()
    }
}
