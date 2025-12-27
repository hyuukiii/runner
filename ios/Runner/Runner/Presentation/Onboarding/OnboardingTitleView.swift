//
//  OnboardingTitleView.swift
//  Runner
//
//  Created by 윤현기 on 12/21/25.
// 공통 타이틀 컴포넌트

import SwiftUI

// MARK: - 시작
struct OnboardingTitleView: View {
    let title: String
    let subTitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
                .lineSpacing(5) // 줄 간격

            Text(subTitle)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.top, 30) // 상단 여백 통일
    }
}
