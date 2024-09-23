//
//  ASAuthorizationAppleIDButton+Extension.swift
//  Moview
//
//  Created by 심관혁 on 9/23/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

extension ASAuthorizationAppleIDButton.Style {
    var backgroundColor: Color {
        switch self {
        case .white:
            return .white
        case .whiteOutline:
            return .white
        default:
            return .black
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .white:
            return .black
        case .whiteOutline:
            return .black
        default:
            return .white
        }
    }
    
    var borderColor: Color {
        switch self {
        case .white:
            return .white
        case .whiteOutline:
            return .black
        default:
            return .black
        }
    }
}

extension ASAuthorizationAppleIDButton.ButtonType {
    var buttonText: String {
        switch self {
        case .signIn:
            return "Sign in with"
        case .continue:
            return "Continue with"
        case .signUp:
            return "Sign up with"
        default:
            return "Sign in with"
        }
    }
}
