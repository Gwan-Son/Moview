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
    
    func resetProfile() {
        print("reset 실행!")
        self.displayName = "Guest"
        self.email = "example@example.com"
        print(displayName,email)
    }
}
