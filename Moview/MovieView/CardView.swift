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
                    NavigationLink(destination: DetailView(movie: movie)) {
                        ZStack {
                            KFImage(URL(string: movie.backdrop_path))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .overlay(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.35)]), startPoint: .top, endPoint: .bottom))
                                .clipShape(.rect(cornerRadius: 15))
                            
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
                }
                .tag(index)
                
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 4)
        .cornerRadius(10)
        .clipped()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: currentPage) { _ in
            resetTimer()
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
    
    func startTimer() { // 화면 자동 전환
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation {
                currentPage = (currentPage + 1) % 4
            }
        }
    }
    
    func stopTimer() { // 백그라운드에서 타이머 종료
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() { // 사용자가 직접 페이지 이동 시 자동 전환 리셋 -> 4초 대기 시간
        stopTimer()
        startTimer()
    }
}

#Preview {
    CardView(viewModel: MovieViewModel(movieService: MovieService()))
}
