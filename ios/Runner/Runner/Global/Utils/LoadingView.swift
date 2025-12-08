//
//  LodingView.swift
//  Runner
//
//  Created by 윤현기 on 12/8/25.
//

import SwiftUI

struct LoadingView: View {
    var message: String = "잠시만 기다려주세요"
    
    var body: some View {
        ZStack {
            // 1. 흰색 배경
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 10) {
                // Lottie 애니메이션 적용
                LottieView(filename: "runner")
                    .frame(width: 250, height: 250) // 크기 조절
                
                // 문구
                Text(message)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, -20) // 애니메이션이랑 너무 멀면 좀 당기기
            }
        }
    }
}

#Preview {
    LoadingView(message: "러닝 상대를 찾으러\n열심히 뛰고 있어요")
}
