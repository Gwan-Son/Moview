//
//  LoginView.swift
//  Moview
//
//  Created by 심관혁 on 9/22/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct LoginView: View {
    
    @Environment(\.auth) private var authManager
    @State private var errorAlert: AnyAppAlert? = nil
    @State var isLogin: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("Moview")
                .font(.system(size: 40))
                .bold()
                .padding(.top, 100)
            
            Spacer()
            
            Button {
                Task {
                    do {
                        let clientId = FirebaseApp.app()?.options.clientID
                        let (userAuthInfo, isNewUser) = try await authManager.signInGoogle(GIDClientID: clientId!)
                        if isNewUser {
                            // New user -> Create user profile in Firestore
                        } else {
                            // Existing user -> sign in
                            print(userAuthInfo)
                        }
                    } catch {
                        // User auth failed
                        errorAlert = AnyAppAlert(error: error)
                    }
                }
            } label: {
                SignInWithGoogleButtonView()
                    .frame(height: 50)
            }
            
            
            Button(action: {
                Task {
                    do {
                        let (userAuthInfo, isNewUser) = try await authManager.signInApple()
                        if isNewUser {
                            // New user -> Create user profile in Firestore
                        } else {
                            // Existing user -> sign in
                            print(userAuthInfo)
                        }
                    } catch {
                        // User auth failed
                        errorAlert = AnyAppAlert(error: error)
                    }
                }
            }, label: {
                SignInWithAppleButtonView()
                    .frame(height: 50)
            })
            
            Button(action: {
                Task {
                    do {
                        try authManager.signOut()
                    }
                }
            }, label: {
                SignInWithGuestButtonView(foregroundColor: .gray)
                    .frame(height: 50)
            })
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .showCustomAlert(alert: $errorAlert)
    }
}

#Preview {
    LoginView()
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}
