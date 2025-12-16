//
//  LoginFlowView.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
// 로그인 플로우 관리자

import SwiftUI

struct LoginFlowView: View {
    // 뷰모델 생성 (StateObject로 수명 관리)
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // NavigationStack: 화면 쌓기 관리자 (iOS 16+)
            NavigationStack(path: $viewModel.navigationPath) {
                
                // 1. 첫 화면: 이메일 입력
                EmailInputView(viewModel: viewModel)
                    // 경로 처리: .codeInput 신호가 오면 CodeInputView로 이동
                    .navigationDestination(for: LoginStep.self) { step in
                        switch step {
                        case .email:
                            EmptyView() // 이메일 단계에선 불 필요
                        case .codeInput:
                            CodeInputView(viewModel: viewModel)
                        case .healthAuth:
                            HealthAuthView(viewModel: viewModel) // viewModel 넘겨주기
                                .navigationBarBackButtonHidden(true)// 건강앱 연동 플로우에서는 뒤로가기 블락
                        case .locationSetting:
                            LocationSettingView(viewModel: viewModel)
                                .navigationBarBackButtonHidden(true)
                        case .nickname:
                            NicknameSettingView(viewModel: viewModel)
                        }
                    } // navigationDestination
                
        } // NavigationStack
        // 로딩 중일 떄 터치 막기 (blur 처리 등 효과 기능)
        .disabled(viewModel.isLoading)
            
        // 로딩 화면 (조건부 등장)
        if viewModel.isLoading {
            LoadingView(message: "인증번호를 보내고 있어요")
                .transition(.opacity) // 부드럽게 나타났다 사라짐
                .zIndex(1) // 제일 위에 표시
            }
            
        } // ZStack
        
    } // body
    
} // LoginFlowView
