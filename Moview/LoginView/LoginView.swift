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
    @EnvironmentObject private var firestoreManager: FirestoreManager
    @State private var errorAlert: AnyAppAlert? = nil
    @State var isLogin: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            LogoView()
                .padding(.top, 100)
            
            Spacer()
            
            
            VStack {
                Button {
                    Task {
                        do {
                            let clientId = FirebaseApp.app()?.options.clientID
                            let (userAuthInfo, isNewUser) = try await authManager.signInGoogle(GIDClientID: clientId!)
                            if isNewUser {
                                // New user -> Create user profile in Firestore
                                firestoreManager.createUserData(userAuthInfo)
                            }
                            self.isLogin.toggle()
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
                                print(userAuthInfo)
                                firestoreManager.createUserData(userAuthInfo)
                            }
                            self.isLogin.toggle()
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
                            self.isLogin.toggle()
                        }
                    }
                }, label: {
                    SignInWithGuestButtonView(foregroundColor: .gray)
                        .frame(height: 50)
                })
            }
            Spacer()
                .frame(height: 50)
        }
        .padding(.horizontal, 15)
        .background(.orange.opacity(0.7))
        .showCustomAlert(alert: $errorAlert)
        .fullScreenCover(isPresented: $isLogin) {
            HomeView()
                .environment(\.isLoggedIn, $isLogin)
        }
    }
    
    
}

#Preview {
    LoginView()
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
        .environmentObject(FirestoreManager())
}
