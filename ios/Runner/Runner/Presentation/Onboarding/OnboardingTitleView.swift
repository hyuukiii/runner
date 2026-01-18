//
//  OnboardingTitleView.swift
//  Runner
//
//  Created by 윤현기 on 12/21/25.
//  공통 타이틀 컴포넌트
//

import SwiftUI

struct OnboardingTitleView: View {
    let title: String
    let subTitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
                .lineSpacing(5) // 줄 간격
                .minimumScaleFactor(0.6) // 공간 부족하면 글자를 60%까지 줄여서라도 다 보여주기
            
            Text(subTitle)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8) // 서브타이틀도 유연하게 줄어듦
        }
        .padding(.horizontal, 24)
    }
}
