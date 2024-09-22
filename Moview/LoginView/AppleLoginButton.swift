//
//  AppleLoginButton.swift
//  Moview
//
//  Created by 심관혁 on 9/22/24.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let result):
                print(result)
                switch result.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let userCredential = appleIDCredential.user
                    let fullName = appleIDCredential.fullName
                    let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                    let email = appleIDCredential.email
                    let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                    let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                default:
                    break
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("error")
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
        .cornerRadius(5)
    }
}


#Preview {
    AppleLoginButton()
}
