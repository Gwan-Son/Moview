//
//  ContentView.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            ForEach(viewModel.movies) { movie in
                Text(movie.title)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
