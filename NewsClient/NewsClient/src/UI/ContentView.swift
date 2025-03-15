//
//  ContentView.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("news")
                }
            FavoriteNewsView()
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("favouriteNews")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
