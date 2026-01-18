//
//  BottomStepButton.swift
//  Runner
//
//  Created by 윤현기 on 12/21/25.
//  공통 버튼 컴포넌트
//

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
                    .font(.headline)
                    .fontWeight(.bold) // 글자 굵기 유지
                
                Text("\(currentStep) / \(totalStep)")
                    .font(.subheadline)
                    .opacity(0.7)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            
            // ✂️ [수정 1] 버튼 높이 다이어트 (18 -> 12)
            .padding(.vertical, 12)
            
            .background(
                RoundedRectangle(cornerRadius: 12) // ✂️ [수정 2] 모서리도 살짝 줄임 (16 -> 12)
                    .fill(isEnabled ? Color.blue : Color.gray.opacity(0.3))
                    .shadow(
                        color: isEnabled ? Color.blue.opacity(0.3) : Color.clear,
                        radius: 8, // 그림자도 살짝 줄임
                        x: 0,
                        y: 4
                    )
            )
        }
        .disabled(!isEnabled)
        
        // 🛡️ [수정 3] 화면 바닥에서 10pt 띄워서 절대 안 잘리게 보호
        .padding(.bottom, 10)
    }
}

#Preview {
    VStack {
        Spacer()
        BottomStepButton(
            title: "다음",
            currentStep: 1,
            isEnabled: true,
            action: {}
        )
        .padding(.horizontal, 24)
    }
}

