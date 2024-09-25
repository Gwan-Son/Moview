//
//  ProfileView.swift
//  Moview
//
//  Created by 심관혁 on 9/25/24.
//

import SwiftUI

struct ProfileView: View {
    let displayName: String
    let email: String
    
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
            } label: {
                Text("프로필 수정")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white, lineWidth: 2))
            }
            .background(.blue)
            .cornerRadius(25)
            
        }
        .padding(.vertical, 10)
    }
}


#Preview {
    ProfileView(displayName: "이름", email: "이메일")
}
