//
//  ProfileView.swift
//  Moview
//
//  Created by 심관혁 on 9/25/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var firestoreManager: FirestoreManager
    @Environment(\.auth) private var authManager
    @State var isPresented: Bool = false
    @State var changeDisplayName: String = ""
    @Binding var displayName: String
    @Binding var email: String
    
    var onDisplayNameChanged: ((String) -> Void)?
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.top, 10)
            Text(displayName)
                .font(.title)
            
            Text(email)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button {
                // TODO: - Change DisplayName
                print("Edit Button Tapped")
                self.isPresented.toggle()
            } label: {
                Text(authManager.currentUser.userId != nil ? "프로필 수정" : "로그인 후 이용해주세요.")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white, lineWidth: 2))
                    .alert("닉네임 변경", isPresented: $isPresented) {
                        TextField(displayName, text: $changeDisplayName)
                            .autocorrectionDisabled(true)
                        Button("확인", action: {
                            if displayName != changeDisplayName {
                                self.displayName = changeDisplayName
                                onDisplayNameChanged?(changeDisplayName)
                            }
                        })
                        Button("취소", role: .cancel, action: {})
                            .foregroundColor(.red)
                    }
            }
            .background(authManager.currentUser.userId != nil ? .blue : .gray)
            .cornerRadius(25)
            .disabled(authManager.currentUser.userId == nil)
            
        }
        .padding(.vertical, 10)
    }
}


#Preview {
    ProfileView(displayName: .constant("이름"), email: .constant("이메일"))
        .environmentObject(FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}
