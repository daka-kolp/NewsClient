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
    private let localStorage: LocalStorageService
    
    init() {
        self.localStorage = LocalStorageService.instance
        initProperties()
    }
    
    @Published var language = "english"
    @Published var region = "usa"
    
    private func initProperties() {
        let languageCode = localStorage.getAppLanguage()
        language = languagesDictionary.first(where: { $0.value == languageCode })?.key ?? "english"

        let regionInfo = localStorage.getNewsRegion()
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
        localStorage.saveAppLanguage(languageCode: languageCode)
    }
    
    func changeRegion(_ region: String) {
        let region = regionsDictionary.first(where: { $0.key == region })?.value ?? RegionInfo.defaultRegion
        localStorage.saveNewsRegion(region: region)
    }
}
