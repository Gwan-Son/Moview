//
//  MoreButton.swift
//  Moview
//
//  Created by 심관혁 on 9/21/24.
//

import SwiftUI

struct MoreButton: View {
    @Environment(\.refresh) private var refresh
    var body: some View {
        Group {
            if let refresh = refresh {
                Button {
                    Task {
                        await refresh()
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 60)
                            .foregroundColor(Color(hex: 0xE5E5E5))
                            .cornerRadius(10)
                        Text("더보기")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    MoreButton()
}
