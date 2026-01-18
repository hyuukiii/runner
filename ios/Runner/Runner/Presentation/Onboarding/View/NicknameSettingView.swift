//
//  NicknameSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/16/25.
//

import SwiftUI
import PhotosUI

struct NicknameSettingView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    // 상태 변수
    @State private var nickname: String = ""
    @FocusState private var isFocused: Bool
    @State private var isLastValid: Bool = false
    @State private var shakeTrigger: CGFloat = 0
    @State private var selectedItem: PhotosPickerItem? = nil
    
    private var isValid: Bool {
        return nickname.count >= 2 && nickname.count <= 10 && !nickname.contains(" ")
    }
    
    // 화면 높이에 따른 반응형 스케일 (SE 모델 등 작은 화면 대응)
    private var uiScale: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight < 700 { return 0.85 } // iPhone SE
        else if screenHeight < 800 { return 0.9 } // iPhone mini
        else { return 1.0 }
    }
    
    var body: some View {
        ZStack {
            // 배경 터치 시 키보드 내리기
            Color.white.ignoresSafeArea()
                .onTapGesture { isFocused = false }
            
            VStack(spacing: 0) {
                
                // 1. 헤더
                BackButtonHeader()
                
                // 2. 메인 콘텐츠 (중앙 정렬)
                VStack(spacing: 0) {
                    
                    Spacer() // 위쪽 여백 자동 조절
                    
                    // 타이틀
                    OnboardingTitleView(
                        title: "나만의 러너 카드를 만들어보세요",
                        subTitle: "사진과 닉네임을 눌러 수정할 수 있어요"
                    )
                    .layoutPriority(1)
                    .padding(.bottom, uiScale < 1.0 ? 10 : 30)
                    
                    // 러너 카드
                    RunnerBibView(
                        nickname: $nickname,
                        image: viewModel.profileImage,
                        selectedItem: $selectedItem,
                        isFocused: $isFocused,
                        onImageChange: { data in
                            if let uiImage = UIImage(data: data) {
                                Task { @MainActor in
                                    viewModel.profileImage = uiImage
                                    HapticManager.instance.impact(style: .light)
                                }
                            }
                        }
                    )
                    .scaleEffect(uiScale) // 화면 작으면 축소
                    .frame(width: 280 * uiScale, height: 340 * uiScale) // 실제 차지하는 공간 축소
                    .onChange(of: nickname) { newValue in
                        handleNicknameChange(newValue)
                    }
                    .onChange(of: isFocused) { focused in
                        if !focused && !isValid && !nickname.isEmpty {
                            HapticManager.instance.notification(type: .error)
                            withAnimation(.default) { shakeTrigger += 1 }
                        }
                    }
                    
                    .modifier(ShakeEffect(animatableData: shakeTrigger))
                    
                    // 하단 메시지
                    HStack(spacing: 10) {
                        if !nickname.isEmpty && !isValid {
                            Image(systemName: "exclamationmark.circle.fill").foregroundColor(.red)
                            Text("2글자 이상 입력해주세요").foregroundColor(.red)
                        } else if isValid {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            Text("멋진 닉네임이에요!").foregroundColor(.green)
                        } else {
                            Text("닉네임은 최대 10글자까지 가능해요").foregroundColor(.gray.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        Text("\(nickname.count) / 10").foregroundColor(isValid ? .gray : .gray.opacity(0.5))
                    }
                    
                    .font(.caption)
                    .padding(.top, 2)
                    .padding(.horizontal, 15)
                    .animation(.easeInOut, value: isValid)
                    
                    Spacer() // 아래쪽 여백 자동 조절
                }
                
                // 3. 하단 버튼
                VStack {
                    BottomStepButton(
                        title: "다음",
                        currentStep: 1,
                        isEnabled: isValid,
                        action: goNext
                    )
                }
                
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - 로직 함수
    private func handleNicknameChange(_ newValue: String) {
        let filtered = newValue.uppercased().replacingOccurrences(of: " ", with: "")
        if filtered.count > 10 {
            nickname = String(filtered.prefix(10))
            HapticManager.instance.impact(style: .rigid)
        } else {
            nickname = filtered
        }
        let currentStatus = (nickname.count >= 2 && nickname.count <= 10)
        if currentStatus != isLastValid {
            if currentStatus { HapticManager.instance.notification(type: .success) }
            isLastValid = currentStatus
        }
    }
    
    private func goNext() {
        viewModel.nickname = nickname
        viewModel.navigationPath.append(.birthDateInfo) // 다음 단계로 이동
    }
}
