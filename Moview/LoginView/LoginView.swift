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
    
    let authManager = AuthManager(configuration: .firebase)
    @Binding var test:Bool
    
    var body: some View {
        VStack {
            Text("google")
            // TODO: - Apple login with Firebase
            AppleLoginButton()
            
            Button(action: {
                Task {
                    do {
                        try await authManager.signInApple()
                        test = true
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                SignInWithAppleButtonView()
                    .frame(height: 50)
            })
            
            SignInWithGoogleButtonView()
                .frame(height: 50)
        }
        .frame(height: UIScreen.main.bounds.height)
        .background(.white)
    }
}

#Preview {
    LoginView(test: .constant(false))
}
