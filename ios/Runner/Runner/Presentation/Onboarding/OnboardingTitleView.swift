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
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .minimumScaleFactor(0.8)
            
            Text(subTitle)
                .font(.footnote)
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
    }
}
