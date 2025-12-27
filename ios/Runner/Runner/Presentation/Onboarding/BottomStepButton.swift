//
//  BottomStepButton.swift
//  Runner
//
//  Created by 윤현기 on 12/21/25.
// 공통 버튼 컴포넌트

import SwiftUI

struct BottomStepButton: View {
    let title: String       // " 다음 " or " 가입 완료 "
    let currentStep: Int    // 1, 2, 3
    let totalStep: Int = 3  // 전체 단계 ( 고정값 )
    let isEnabled: Bool     // 버튼 활성화 여부
    let action: () -> Void  // 클릭 시 실행 할 함수
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.headline).fontWeight(.bold)
                
                Text("\(currentStep) / \(totalStep)")
                    .font(.subheadline)
                    .opacity(0.7)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(isEnabled ? Color.blue : Color.gray.opacity(0.3))
            .cornerRadius(16)
            // 그림자 로직도 여기서 한번에
            .shadow(color: isEnabled ? Color.blue.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!isEnabled)
    }
}

