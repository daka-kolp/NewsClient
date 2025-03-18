//
//  LocalStorageService.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 18.03.2025.
//


import Foundation

class LocalStorageService {
    static let instance = LocalStorageService()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let languageKey = "languageCode"
    private let regionKey = "region"
    
    func saveAppLanguage(languageCode: String) {
        defaults.set(languageCode, forKey: languageKey)
    }
    
    func getAppLanguage() -> String {
        return defaults.string(forKey: languageKey) ?? defaultLanguage
    }
    
    func saveNewsRegion(region: RegionInfo) {
        if let encodedRegion = try? encoder.encode(region) {
            defaults.set(encodedRegion, forKey: regionKey)
        }
    }
    
    func getNewsRegion() -> RegionInfo {
        if let savedRegionData = defaults.object(forKey: regionKey) as? Data {
            guard let savedRegion = try? decoder.decode(RegionInfo.self, from: savedRegionData) else {
                return RegionInfo.defaultRegion
            }
            return savedRegion
        }
        return RegionInfo.defaultRegion
    }
    
    func clear() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in defaults.removeObject(forKey: key) }
    }
}
