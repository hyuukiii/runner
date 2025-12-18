//
//  NicknameSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/16/25.
// TODO: 다음 버튼에 1 / 3 기능 넣기 , 닉네임 입력칸 허전해서 UI/UX 적으로 개선하기 , 유효성 검사 로직은 실행 될 때만 보여주기

import SwiftUI
import PhotosUI // 앨범 접근용

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
                        Text("나만의 러너 카드를 만들어보세요 ")
                            .font(.system(size: 24, weight: .bold))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                        
                        Text("사진과 닉네임을 눌러 수정할 수 있어요")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 45)
                    
                    // 러너 카드
                    RunnerBibView(
                        nickname: $nickname, // Binding으로 전달
                        image: viewModel.profileImage,
                        selectedItem: $selectedItem,
                        isFocused: _isFocused, // FocusState 전달
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
                    
                    // 4. [수정됨] 하단 상태 메시지 (입력창 삭제하고 메시지만 남김)
                    HStack(spacing: 10) {
                        // 에러/성공 메시지
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
                            // 비어있을 땐 힌트
                            Text("닉네임은 최대 10글자까지 가능해요")
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        // 글자 수
                        Text("\(nickname.count) / 10")
                            .foregroundColor(isValid ? .gray : .gray.opacity(0.5))
                    }
                    .font(.caption)
                    .padding(.horizontal, 40) // 카드 너비랑 비슷하게 맞춤
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
            // 카드 자체가 입력창이니 바로 키보드 띄워주기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isFocused = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - 로직 함수
    private func handleNicknameChange(_ newValue: String) {
        // 대문자로 강제 변환 (배번표 느낌 살리기) & 공백 제거
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

// MARK: - 러너 카드 (입력 기능 포함)
struct RunnerBibView: View {
    @Binding var nickname: String // Binding으로 변경
    var image: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    @FocusState var isFocused: Bool // 포커스 제어
    var onImageChange: (Data) -> Void
    
    var body: some View {
        ZStack {
            // 종이느낌의 배경
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .frame(width: 280, height: 340)
            
            // 러너 카드 끝쪽 4부분의 구멍 UI
            VStack {
                HStack { Circle().frame(width: 12); Spacer(); Circle().frame(width: 12) }
                Spacer()
                HStack { Circle().frame(width: 12); Spacer(); Circle().frame(width: 12) }
            }
            .foregroundColor(Color.gray.opacity(0.2))
            .padding(15)
            .frame(width: 280, height: 340)
            
            // 내용물
            VStack(spacing: 20) {
                Text("RUNNING MATE")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.gray.opacity(0.5))
                    .tracking(2)
                
                // 프로필 사진 UI
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.1), lineWidth: 1))
                        } else {
                            ZStack {
                                Circle().fill(Color.gray.opacity(0.05))
                                Circle().strokeBorder(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.blue.opacity(0.5))
                            }
                            .frame(width: 120, height: 120)
                        }
                    }
                    .frame(width: 120, height: 120)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            onImageChange(data)
                        }
                    }
                }
                
                // 러너 카드 내부의 닉네임 입력하는 곳 (RUNNER)
                VStack(spacing: 4) {
                    TextField("RUNNER", text: $nickname)
                        .font(.system(size: 40, weight: .heavy)) // 배번표 폰트
                        .multilineTextAlignment(.center) // 가운데 정렬
                        .focused($isFocused)
                        .textInputAutocapitalization(.characters) // 자동 대문자
                        .foregroundColor(.black)
                        .tint(.blue) // 커서 색상
                        .frame(height: 50)
                        .minimumScaleFactor(0.5)
                    
                    
                }
                
                // 바코드 UI
                HStack(spacing: 4) {
                    ForEach(0..<15) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.8))
                            .frame(width: CGFloat.random(in: 2...12), height: 20)
                    }
                }
                .opacity(0.3)
            }
            .padding(.vertical, 30)
            .frame(width: 280)
        }
    }
}

#Preview {
    NicknameSettingView(viewModel: LoginViewModel())
}
