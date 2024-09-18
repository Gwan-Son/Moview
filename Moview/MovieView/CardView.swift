//
//  CardView.swift
//  Moview
//
//  Created by 심관혁 on 9/17/24.
//

import SwiftUI
import Kingfisher

struct CardView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var currentPage = 0
    @State private var timer: Timer?
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(viewModel.popularMovies.prefix(4).enumerated()), id: \.element) { index, movie in
                
                VStack(alignment: .leading) {
                    ZStack {
                        KFImage(URL(string: movie.poster_path))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.35)]), startPoint: .top, endPoint: .bottom))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            Text(movie.title)
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            CircularProgressView(progress: movie.vote_average)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 4 ,alignment: .leading)
                        .padding(.bottom, 20)
                        .padding(.leading, 10)
                        
                    }
                }
                .tag(index)
                
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 4)
        .cornerRadius(15)
        .clipped()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        HStack(spacing: 8) {
            ForEach(0..<4) { index in
                Circle()
                    .fill(currentPage == index ? Color.orange : Color.gray)
                    .frame(width: 8, height: 8)
                    .onTapGesture {
                        currentPage = index
                    }
            }
        }
        .padding(.top, 8)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation {
                currentPage = (currentPage + 1) % 4
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    CardView(viewModel: MovieViewModel(movieService: MovieService()))
}
