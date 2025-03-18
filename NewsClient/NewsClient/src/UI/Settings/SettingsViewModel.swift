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
    
    @Published var language = "english"
    @Published var region = "usa"
    
    private func initProperties() {
        let languageCode = localStorage.language
        language = languagesDictionary.first(where: { $0.value == languageCode })?.key ?? "english"

        let regionInfo = localStorage.region
        region = regionsDictionary.first(where: { $0.value == regionInfo })?.key ?? "usa"
    }
    
    let languages: [String] = ["english", "ukrainian"]
    
    let regions: [String] = ["usa", "unitedKingdom", "ukraine", "france"]
    
    let languagesDictionary = [
        "english": defaultLanguage,
        "ukrainian": "ua",
    ]
    
    let regionsDictionary = [
        "usa": RegionInfo.defaultRegion,
        "unitedKingdom": RegionInfo(regionCode: "gb", languageCode: "en"),
        "france": RegionInfo(regionCode: "fr", languageCode: "fr"),
        "ukraine": RegionInfo(regionCode: "ua", languageCode: "ru"),
    ]
    
    func changeLanguage(_ language: String) {
        let languageCode = languagesDictionary.first(where: { $0.key == language })?.value ?? defaultLanguage
        localStorage.language = languageCode
    }
    
    func changeRegion(_ region: String) {
        let region = regionsDictionary.first(where: { $0.key == region })?.value ?? RegionInfo.defaultRegion
        localStorage.region = region
    }
    
    func clearCache() async {
        await repo.clearSD()
        
        localStorage.clear()
        initProperties()
    }
}
