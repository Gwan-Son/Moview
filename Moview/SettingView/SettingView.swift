//
//  SettingView.swift
//  Moview
//
//  Created by 심관혁 on 9/25/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var firestoreManager: FirestoreManager
    @Environment(\.auth) private var authManager
    @Environment(\.isLoggedIn) var isLoggedIn
    @StateObject var viewModel: SettingViewModel = SettingViewModel()
    @State var isLogoutAlertPresented: Bool = false
    @State var isUnregisterAlertPresented: Bool = false
    @State var isDeleteFavoriteAlertPresented: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    HStack {
                        Spacer()
                        ProfileView(displayName: $viewModel.displayName, email: $viewModel.email) { newName in
                            firestoreManager.updateUserData(authManager.currentUser.userId!, updateName: newName)
                        }
                        Spacer()
                    }
                }
                Section(header: Text("컨텐츠")) {
                    HStack {
                        Image(systemName: "star.slash.fill")
                        Button {
                            self.isDeleteFavoriteAlertPresented.toggle()
                        } label: {
                            Text("즐겨찾기 초기화")
                                .alert(isPresented: $isDeleteFavoriteAlertPresented) {
                                    Alert(title: Text("즐겨찾기 초기화"), message: Text("초기화하시겠습니까?"), primaryButton: .destructive(Text("확인"), action: {
                                        firestoreManager.deleteFavorite(authManager.currentUser.userId!)
                                    }), secondaryButton: .cancel(Text("취소")))
                                }
                        }
                        .disabled(authManager.currentUser.userId == nil)
                    }
                }
                
                Section(header: Text("계정")) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Button {
                            self.isLogoutAlertPresented.toggle()
                        } label: {
                            Text("로그아웃")
                                .alert(isPresented: $isLogoutAlertPresented) {
                                    Alert(title: Text("로그아웃"), message: Text("로그아웃하시겠습니까?"), primaryButton: .destructive(Text("확인"), action: {
                                        Task {
                                            do {
                                                try authManager.signOut()
                                                viewModel.resetProfile()
                                                firestoreManager.resetUserData()
                                                isLoggedIn.wrappedValue = false
                                            }
                                        }
                                    }), secondaryButton: .cancel(Text("취소")))
                                }
                        }
                    }
                    HStack {
                        Image(systemName: "trash.fill")
                        Button {
                            self.isUnregisterAlertPresented.toggle()
                        } label: {
                            Text("회원탈퇴")
                                .foregroundColor(authManager.currentUser.userId != nil ? .red : .gray)
                                .alert(isPresented: $isUnregisterAlertPresented) {
                                    Alert(title: Text("회원탈퇴"), message: Text("회원탈퇴하시겠습니까?"), primaryButton: .destructive(Text("확인"), action: {
                                        Task {
                                            do {
                                                firestoreManager.deleteUserData(authManager.currentUser.userId!)
                                                try await authManager.deleteAuthentication()
                                                try authManager.signOut()
                                                viewModel.resetProfile()
                                                firestoreManager.resetUserData()
                                                isLoggedIn.wrappedValue = false
                                            }
                                        }
                                    }), secondaryButton: .cancel(Text("취소")))
                                }
                        }
                        .disabled(authManager.currentUser.userId == nil)
                    }
                }
            }
            .navigationTitle("설정")
            .onAppear {
                viewModel.loadProfile(name: firestoreManager.userData.displayName, email: firestoreManager.userData.email)
            }
        }
        
    }
}

#Preview {
    SettingView()
        .environmentObject(FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
        .environment(\.isLoggedIn, .constant(true))
}

