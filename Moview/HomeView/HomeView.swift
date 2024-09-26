//
//  TabView.swift
//  Moview
//
//  Created by 심관혁 on 9/24/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.auth) private var authManager
    @Binding var isPresented: Bool
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationStack {
                MovieView()
            }
            .tabItem({
                viewModel.selectedTab == .movie ? Image(systemName: "movieclapper.fill") : Image(systemName: "movieclapper")
                Text("Movies")
            })
            .tag(Tab.movie)
            
            Text("Favorite")
                .tabItem({
                    viewModel.selectedTab == .favorite ? Image(systemName: "star.fill") : Image(systemName: "star")
                    Text("Favorite")
                })
                .tag(Tab.favorite)
            
            SettingView(isPresented: $isPresented)
                .tabItem({
                    viewModel.selectedTab == .setting ? Image(systemName: "gearshape.fill") : Image(systemName: "gearshape")
                    Text("Setting")
                })
                .tag(Tab.setting)
        }
        .accentColor(.orange)
        .environmentObject(firestoreManager)
//        .environment(\.auth, AuthManager(configuration: .firebase))
    }
}

#Preview {
    HomeView(isPresented: .constant(true))
        .environment(\.db, FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}
