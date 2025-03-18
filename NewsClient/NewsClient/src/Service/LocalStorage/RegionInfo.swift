//
//  RegionInfo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 18.03.2025.
//


struct RegionInfo: Codable, Equatable {
    let regionCode: String
    let languageCode: String
    
    static let defaultRegion = RegionInfo(regionCode: "us", languageCode: "en")
}
