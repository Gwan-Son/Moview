//
//  FavoriteView.swift
//  Moview
//
//  Created by 심관혁 on 10/15/24.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject private var firestoreManager: FirestoreManager
    @Environment(\.auth) private var authManager
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FavoriteView()
        .environmentObject(FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}
