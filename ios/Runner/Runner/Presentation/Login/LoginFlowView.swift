//
//  LoginFlowView.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//

import SwiftUI

struct LoginFlowView: View {
    // 뷰모델 생성 (StateObject로 수명 관리)
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        // NavigationStack: 화면 쌓기 관리자 (iOS 16+)
        NavigationStack(path: $viewModel.navigationPath) {
            
            // 1. 첫 화면: 이메일 입력
            EmailInputView(viewModel: viewModel)
                // 경로 처리: .codeInput 신호가 오면 CodeInputView로 이동해라
                .navigationDestination(for: LoginStep.self) { step in
                    switch step {
                    case .email:
                        EmptyView() // 이메일 단계에선 불 필요
                    case .codeInput:
                        CodeInputView(viewModel: viewModel)
                    case .healthAuth:
                        HealthAuthView()
                            .navigationBarBackButtonHidden(true)// 건강앱 연동 플로우에서는 뒤로가기 블락
                    
                    }
                } // navigationDestination
        
        } // NavigationStack
        
    } // body
    
} // LoginFlowView

#Preview {
    LoginFlowView()
}
