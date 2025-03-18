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
    
    private let articleLanguageCodeKey = "articleLanguage"
    
    var articleLanguage: String {
        get {
            return defaults.string(forKey: articleLanguageCodeKey) ?? defaultLanguageCode
        }
        set {
            defaults.setValue(newValue, forKey: articleLanguageCodeKey)
        }
    }
    
    func clear() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in defaults.removeObject(forKey: key) }
    }
}
