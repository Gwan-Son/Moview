//
//  CircularProgressView.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    
    private var progressColor: Color {
        switch progress {
        case 0.7...1.0:
            return .green
        case 0.4..<0.7:
            return .yellow
        default:
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: 0x081C22))
                .frame(width: 34, height: 34)
            
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 3
                )
                .frame(width: 28, height: 28)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .frame(width: 28, height: 28)
            
            HStack {
                Text("\(Int(progress * 100))")
                    .font(.system(size: 10))
                    .bold()
                
                Text("%")
                    .font(.system(size: 4))
                    .padding(.leading, -8)
                    .padding(.bottom, 5)
            }
            .foregroundColor(.white)
            .padding(.leading, 5)
            
        }
        .frame(width: 34, height: 34)
    }
}

#Preview {
    CircularProgressView(progress: 0.77)
}
