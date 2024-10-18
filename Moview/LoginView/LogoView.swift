//
//  LogoView.swift
//  Moview
//
//  Created by 심관혁 on 10/18/24.
//

import SwiftUI

struct LogoView: View {
    @State private var isJumping: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Text("M")
                .offset(y: isJumping ? 0 : -10)
            Text("o")
            Text("V")
                .offset(y: isJumping ? 0 : -10)
            Text("iew")
        }
        .font(.system(size: 40, weight: .bold))
        .foregroundColor(.white)
        .shadow(radius: 10)
        .frame(height: 50)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(3)) {
                isJumping.toggle()
            }
        }
    }
}

#Preview {
    LogoView()
}
