//
//  LodingView.swift
//  Runner
//
//  Created by 윤현기 on 12/8/25.
//

import SwiftUI
import Combine
struct LoadingView: View {
    var message: String = "잠시만 기다려주세요"
    
    // 발바꿈 상태 ddd(왼발/오른발)
    @State private var runFrame = false
    
    // 타이머: 0.15초마다 발을 구름
    let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // 달리는 사람
                Image(systemName: "figure.run")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    // 0.15초마다 좌우 반전 -> 다리가 교차하는 것처럼 보임
                    .scaleEffect(x: runFrame ? 1 : -1, y: 1)
                    // 뛸 때마다 살짝 위로 튀어오름 (역동성)
                    .offset(y: runFrame ? -5 : 0)
                
                // 문구
                Text(message)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        // 0.15초마다 타이머 신호를 받아서 발을 바꿈 (탁! 탁! 탁!)
        .onReceive(timer) { _ in
            runFrame.toggle()
        }
    }
}

#Preview {
    LoadingView(message: "러닝 상대를 찾으러\n열심히 뛰고 있어요!")
}
