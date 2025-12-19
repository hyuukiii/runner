//
//  NicknameSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/16/25.
// TODO: 다음 버튼에 1 / 3 기능 넣기 , 닉네임 입력칸 허전해서 UI/UX 적으로 개선하기 , 유효성 검사 로직은 실행 될 때만 보여주기

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
    @Environment(\.dismiss) private var dismiss
    
    // 상태 변수
    @State private var nickname: String = ""
    @FocusState private var isFocused: Bool
    @State private var isLastValid: Bool = false
    @State private var shakeTrigger: CGFloat = 0
    @State private var selectedItem: PhotosPickerItem? = nil
    
    private var isValid: Bool {
        return nickname.count >= 2 && nickname.count <= 10 && !nickname.contains(" ")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. 상단 네비게이션
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) { // 간격 시원하게 조정
                    
                    // 2. 타이틀
                    VStack(spacing: 8) {
                        Text("나만의 러너 카드를\n만들어보세요") // 줄바꿈 추가하면 더 예쁨
                            .font(.system(size: 24, weight: .bold))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                        
                        Text("사진과 닉네임을 눌러 수정할 수 있어요")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 45)
                    
                    // 3. 러너 카드 (컴포넌트 호출)
                    RunnerBibView(
                        nickname: $nickname,
                        image: viewModel.profileImage,
                        selectedItem: $selectedItem,
                        isFocused: $isFocused, // $를 붙여서 바인딩 전달
                        onImageChange: { data in
                            if let uiImage = UIImage(data: data) {
                                Task { @MainActor in
                                    viewModel.profileImage = uiImage
                                    HapticManager.instance.impact(style: .light)
                                }
                            }
                        }
                    )
                    // 텍스트 변경 로직 (진동 등)
                    .onChange(of: nickname) { newValue in
                        handleNicknameChange(newValue)
                    }
                    // 포커스 해제 시 검사 로직
                    .onChange(of: isFocused) { focused in
                        if !focused && !isValid && !nickname.isEmpty {
                            HapticManager.instance.notification(type: .error)
                            withAnimation(.default) { shakeTrigger += 1 }
                        }
                    }
                    .modifier(ShakeEffect(animatableData: shakeTrigger))
                    
                    // 4. 하단 상태 메시지
                    HStack(spacing: 10) {
                        if !nickname.isEmpty && !isValid {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text("2글자 이상 입력해주세요")
                                .foregroundColor(.red)
                        } else if isValid {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("멋진 닉네임이에요!")
                                .foregroundColor(.green)
                        } else {
                            Text("닉네임은 최대 10글자까지 가능해요")
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        Text("\(nickname.count) / 10")
                            .foregroundColor(isValid ? .gray : .gray.opacity(0.5))
                    }
                    .font(.caption)
                    .padding(.horizontal, 40)
                    .animation(.easeInOut, value: isValid)
                    
                }
                .padding(.bottom, 50)
            }
            // 배경 터치 시 키보드 내리기
            .onTapGesture {
                isFocused = false
            }
            
            // 5. 하단 버튼
            VStack {
                Button(action: { goNext() }) {
                    HStack(spacing: 8) {
                        Text("다음")
                            .font(.headline).fontWeight(.bold)
                        Text("1 / 3")
                            .font(.subheadline).opacity(0.7)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(isValid ? Color.blue : Color.gray.opacity(0.3))
                    .cornerRadius(16)
                    .shadow(color: isValid ? Color.blue.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                }
                .disabled(!isValid)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 10)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isFocused = true
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
        viewModel.navigationPath.append(.genderInfo)
    }
}

#Preview {
    NicknameSettingView(viewModel: LoginViewModel())
}
