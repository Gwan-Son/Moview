//
//  DetailGenreView.swift
//  Moview
//
//  Created by 심관혁 on 9/19/24.
//

import SwiftUI

struct DetailGenreView: View {
    let genres: [Genre]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(genres, id: \.id) { genre in
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(hex: 0xE5E5E5))
                            .padding(.horizontal, -5)
                            .frame(height: 20)
                            .cornerRadius(10)
                        
                        Text(genre.name)
                            .font(.system(size: 12))
                            .padding(.horizontal, 5)
                    }
                }
            }
        }
    }
}


#Preview {
    DetailGenreView(genres: [])
}
