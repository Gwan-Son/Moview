//
//  DividerCategory.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import SwiftUI

struct DividerCategoryView: View {
    var dividerText: String
    
    var body: some View {
        HStack {
            Text(dividerText)
                .font(.system(size: 20))
                .bold()
            
            Spacer()
            
            NavigationLink(destination: EmptyView()) {
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
    DividerCategoryView(dividerText: "인기 영화")
}
