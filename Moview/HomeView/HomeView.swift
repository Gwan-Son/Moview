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
    @Environment(\.isLoggedIn) var isLoggedIn
    
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
            
            FavoriteView()
                .tabItem({
                    viewModel.selectedTab == .favorite ? Image(systemName: "star.fill") : Image(systemName: "star")
                    Text("Favorite")
                })
                .tag(Tab.favorite)
            
            SettingView()
                .environment(\.isLoggedIn, isLoggedIn)
                .tabItem({
                    viewModel.selectedTab == .setting ? Image(systemName: "gearshape.fill") : Image(systemName: "gearshape")
                    Text("Setting")
                })
                .tag(Tab.setting)
        }
        .accentColor(.orange)
        .onAppear {
            if let uid = authManager.currentUser.userId {
                firestoreManager.loadUserData(uid)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}
