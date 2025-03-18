//
//  LocalStorageService.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 18.03.2025.
//


import Foundation

@Observable
class LocalStorageService {
    static let instance = LocalStorageService()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let languageKey = "languageCode"
    private let regionKey = "region"
    
    var language: String {
        get {
            access(keyPath: \.languageKey)
            return defaults.string(forKey: languageKey) ?? defaultLanguage
        }
        set {
            withMutation(keyPath: \.languageKey) {
                defaults.setValue(newValue, forKey: languageKey)
            }
        }
    }
    
    var region: RegionInfo {
        get {
            access(keyPath: \.regionKey)
            if let savedRegionData = defaults.object(forKey: regionKey) as? Data {
                guard let savedRegion = try? decoder.decode(RegionInfo.self, from: savedRegionData) else {
                    return RegionInfo.defaultRegion
                }
                return savedRegion
            }
            return RegionInfo.defaultRegion
        }
        set {
            withMutation(keyPath: \.regionKey) {
                if let encodedRegion = try? encoder.encode(newValue) {
                    defaults.set(encodedRegion, forKey: regionKey)
                }
            }
        }
    }
    
    func clear() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in defaults.removeObject(forKey: key) }
    }
}
