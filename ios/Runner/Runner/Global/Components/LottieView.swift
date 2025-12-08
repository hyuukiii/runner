//
//  LottieView.swift
//  Runner
//
//  Created by 윤현기 on 12/8/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> UIView {
        // 1. 뷰 생성
        let view = UIView(frame: .zero)
        
        // 2. 애니메이션 설정
        let animationView = LottieAnimationView(name: filename)
        animationView.contentMode = .scaleAspectFit // 비율 유지하며 꽉 채우기
        animationView.loopMode = loopMode // 무한 반복
        animationView.play() // 재생 시작!
        
        // 3. 오토레이아웃 (화면 크기에 맞춰 늘어나게 설정)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
