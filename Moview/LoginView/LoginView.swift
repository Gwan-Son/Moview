//
//  LoginView.swift
//  Moview
//
//  Created by 심관혁 on 9/22/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Text("google")
            // TODO: - Apple login with Firebase
            AppleLoginButton()

        }
        .frame(height: UIScreen.main.bounds.height)
        .background(.white)
    }
}

#Preview {
    LoginView()
}

