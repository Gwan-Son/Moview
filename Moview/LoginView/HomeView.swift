//
//  TabView.swift
//  Moview
//
//  Created by 심관혁 on 9/24/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            MovieView()
                .tabItem({
                    viewModel.selectedTab == .movie ? Image(systemName: "movieclapper.fill") : Image(systemName: "movieclapper")
                    Text("Movie")
                })
                .tag(Tab.movie)
            
            Text("Favorite")
                .tabItem({
                    viewModel.selectedTab == .favorite ? Image(systemName: "star.fill") : Image(systemName: "star")
                    Text("Favorite")
                })
                .tag(Tab.favorite)
            
            Text("Setting")
                .tabItem({
                    viewModel.selectedTab == .setting ? Image(systemName: "gearshape.fill") : Image(systemName: "gearshape")
                    Text("Setting")
                })
                .tag(Tab.setting)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    HomeView()
}
