//
//  ShakeEffect.swift
//  Runner
//
//  Created by 윤현기 on 12/8/25.
//

import SwiftUI

// 뷰를 좌우로 흔들어주는 효과 (GeometryEffect 사용)
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10       // 얼마나 세게 흔들지
    var shakesPerUnit: CGFloat = 3 // 몇 번 흔들지
    var animatableData: CGFloat    // 에니메이션 진행도
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        // sin 함수를 이용해 좌우 (-1 ~ 1)로 흔들림을 만든다
        let translation = amount * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
