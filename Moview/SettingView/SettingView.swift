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
    @StateObject var viewModel: SettingViewModel = SettingViewModel()
    @Binding var isPresented: Bool
    @State var isLogoutAlertPresented: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    HStack {
                        Spacer()
                        ProfileView(displayName: viewModel.displayName, email: viewModel.email)
                            .environment(\.db, FirestoreManager())
                        Spacer()
                    }
                }
                Section(header: Text("컨텐츠")) {
                    HStack {
                        Image(systemName: "eye")
                        Button {
                            // TODO: - See Coments
                        } label: {
                            Text("작성 댓글 보기")
                        }
                    }
                    HStack {
                        Image(systemName: "star.slash.fill")
                        Button {
                            // TODO: - Delete Favorite List
                            print("즐겨찾기 초기화")
                        } label: {
                            Text("즐겨찾기 초기화")
                        }
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
                                                isPresented.toggle()
                                            }
                                        }
                                    }), secondaryButton: .cancel(Text("취소")))
                                }
                        }
                    }
                    HStack {
                        Image(systemName: "trash.fill")
                        Button {
                            // TODO: - Delete Uesr
                        } label: {
                            Text("회원탈퇴")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("설정")
            .onAppear {
                if let uid = authManager.currentUser.userId {
                    let data = firestoreManager.loadDisplayName(uid)
                    viewModel.loadProfile(name: data.0, email: data.1)
                }
            }
        }
        
    }
}

#Preview {
    SettingView(isPresented: .constant(true))
        .environment(\.db, FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}

