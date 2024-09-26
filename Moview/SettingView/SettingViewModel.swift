//
//  SettingViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/27/24.
//

import Foundation

class SettingViewModel: ObservableObject {
    @Published var displayName: String = "Guest"
    @Published var email: String = "example@example.com"
    
    func loadProfile(name: String?, email: String?) {
        if name != nil && email != nil {
            self.displayName = name!
            self.email = email!
        }
    }
}
