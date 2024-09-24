//
//  HomeViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/24/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    
    init(selectedTab:Tab =  .movie) {
        self.selectedTab = selectedTab
    }
}

extension HomeViewModel {
    func changeTab(_ tab: Tab) {
        selectedTab = tab
    }
}
