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
    @Published var language = "english"
    @Published var region = "usa"
    
    let languages: [String] = ["english", "ukrainian"]
    
    let regions: [String] = ["usa", "ukraine"]
}
