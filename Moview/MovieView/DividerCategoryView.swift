//
//  DividerCategory.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import SwiftUI

struct DividerCategoryView: View {
    @StateObject var viewModel = SeeAllViewModel(movieService: MovieService())
    var category: MovieCategory
    
    var body: some View {
        HStack {
            Text(category.name)
                .font(.system(size: 20))
                .bold()
            
            Spacer()
            
            NavigationLink(destination: SeeAllView(category: category, viewModel: viewModel)) {
                Text("모두 보기")
                    .font(.system(size: 13))
                    .foregroundColor(.orange)
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

#Preview {
    DividerCategoryView(category: .nowPlaying)
}
