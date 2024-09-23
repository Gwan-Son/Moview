//
//  SignInWithGoogleButtonView.swift
//  Moview
//
//  Created by 심관혁 on 9/23/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

public struct SignInWithGoogleButtonView: View {
    
    private var backgroundColor: Color
    private var foregroundColor: Color
    private var borderColor: Color
    private var buttonText: String
    private var cornerRadius: CGFloat
        
    public init(
        type: ASAuthorizationAppleIDButton.ButtonType = .signIn,
        style: ASAuthorizationAppleIDButton.Style = .black,
        cornerRadius: CGFloat = 10
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = style.backgroundColor
        self.foregroundColor = style.foregroundColor
        self.borderColor = style.borderColor
        self.buttonText = type.buttonText
    }
    
    public init(
        type: ASAuthorizationAppleIDButton.ButtonType = .signIn,
        backgroundColor: Color = Color("GoogleRed"),
        borderColor: Color = Color("GoogleRed"),
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 10
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.foregroundColor = foregroundColor
        self.buttonText = type.buttonText
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(borderColor)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .padding(0.8)
            
            HStack(spacing: 8) {
                Image("GoogleIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text("\(buttonText) Google")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
            }
            .foregroundColor(foregroundColor)
        }
        .padding(.vertical, 1)
        .disabled(true)
    }
}

#Preview("SignInWithGoogleButtonView") {
    SignInWithGoogleButtonView(backgroundColor: .googleRed)
        .frame(height: 60)
        .padding()
}
