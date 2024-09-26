//
//  SettingView.swift
//  Moview
//
//  Created by 심관혁 on 9/25/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.db) private var firestoreManager: FirestoreManager
    @Environment(\.auth) private var authManager
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    HStack {
                        Spacer()
                        ProfileView(displayName: "name", email: "email")
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
                            // TODO: - SignOut
                        } label: {
                            Text("로그아웃")
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
        }
        
    }
}

#Preview {
    SettingView()
        .environment(\.db, FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}

