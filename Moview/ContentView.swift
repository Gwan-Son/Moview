//
//  ContentView.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    @State private var currentPage = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            // 추천 영화
            TabView(selection: $currentPage) {
                ForEach(Array(viewModel.movies.prefix(4).enumerated()), id: \.element) { index, movie in
                    
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
                                
                                Text(movie.vote_average)
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundColor(.white)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 4 ,alignment: .leading)
                            .padding(.bottom, 20)
                            
                        }
                    }
                    .tag(index)
                    
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 4)
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
            
            
            // 인기 영화
            Text("인기 영화")
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        VStack(spacing: 10) {
                            KFImage(URL(string: movie.poster_path))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .shadow(radius: 10)
                            
                            VStack {
                                Text(movie.title)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 100)
                                
                                Text(movie.original_title)
                                    .font(.system(size: 10))
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 100)
                                
                                Text(movie.vote_average)
                                    .font(.system(size: 10))
                            }
                            
                        }
                    }
                }
            }
        }
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
    ContentView()
}
