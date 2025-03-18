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
                Picker("language", selection: $viewModel.language) {
                    ForEach(viewModel.languages, id: \.self) {
                        Text(LocalizedStringKey($0))
                    }
                }
                .onChange(of: viewModel.language) { _, newValue in
                    onLanguageChanged(newValue)
                }
                
                Picker("region", selection: $viewModel.region) {
                    ForEach(viewModel.regions, id: \.self) {
                        Text(LocalizedStringKey($0))
                    }
                }
                .onChange(of: viewModel.region) { _, newValue in
                    onRegionChanged(newValue)
                }
                
                Button ("clearCache") { clearCache() }
            }
            .navigationTitle("settings")
        }
    }
    
    func onLanguageChanged(_ language: String) {
        viewModel.changeLanguage(language)
    }
    
    func onRegionChanged(_ region: String) {
        viewModel.changenRegion(region)
    }
    
    func clearCache() {
        
    }
}

//#Preview {
//    SettingsView()
//}
