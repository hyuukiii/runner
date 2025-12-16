//
//  NicknameSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/16/25.
//

import SwiftUI

struct NicknameSettingView: View {
    // 이전 화면(LoginFlow)에서 주입받을 뷰모델
    @ObservedObject var viewModel: LoginViewModel
    
    // 닉네임 입력 상태 관리
    @State private var nickname: String = ""
    @FocusState private var isFocused: Bool
    
    // 유효성 검사 ( 2~10자, 공백 없음 )
    private var isValid: Bool {
        return nickname.count >= 2 && nickname.count <= 10 && !nickname.contains(" ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // 1. 상단 안내 문구
            VStack(alignment: .leading, spacing: 10) {
                Text("어떤 닉네임으로 불러드릴까요?")
                    .font(.title)// 큰 제목
                    .fontWeight(.bold)
                    .lineSpacing(4) // 줄 간격 살짝 띄우기
                
                Text("러닝 메이트들에게 보여질 이름 이에요")
                    .font(.body)
                    .foregroundColor(.gray)
                
            } // 안내 문구 VStack
            .padding(.top, 40)
            
            // 2. 닉네임 입력창
            VStack(alignment: .leading) {
                TextField("닉네임 입력", text: $nickname)
                    .font(.title2)
                    .focused($isFocused) // 화면 켜지면 바로 포커스됨
                    .padding(.vertical, 10)
                    .onChange(of: nickname) { _ in
                        // 글자 수 10자 제한
                        if nickname.count > 10 {
                            nickname = String(nickname.prefix(10))
                        }
                    }
                
                // 밑줄 디자인
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isValid ? .blue : .gray.opacity(0.3))
                
                // 유효성 안내 메시지 (조건 안 맞을 때만 표시)
                if !nickname.isEmpty && !isValid {
                    Text("10글자 아래로 설정할 수 있어요")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
            }
            .padding(.top, 30)
            
            Spacer()
            
            //3. 다음 버튼
            Button(action: {
                goNext()
            }) {
                Text("다음")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isValid ? Color.blue : Color.gray.opacity(0.3)) // 비활성화 시 회색
                    .cornerRadius(14)
            }
            .disabled(!isValid) // 유효하지 않으면 클릭 불가
            .padding(.bottom, 10) // 키보드 올라오면 자동으로 위치 조정됨
        }
        .padding(.horizontal, 24)
        .onAppear {
            // 화면 진입 시 0.5초 뒤 키보드 올리기 (자연스러운 UX)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
            .toolbar {
                // 네비게이션 바 뒤로가기 버튼 커스텀 (필요 시)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // 뒤로가기 로직 (보통 네비게이션 스택에서 자동 처리 됨)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        } // 부모 VStack
        
        // 다음 화면으로 이동
        private func goNext() {
            print("입력된 닉네임: \(nickname)")
            
            // 1. 뷰모델에 닉네임 저장
            // viewModel.nickname = nickname
                    
            // 2. 다음 단계(성별/나이)로 네비게이션 이동
            // viewModel.navigationPath.append(.genderInfo)
        }
    }


// 프리뷰
#Preview {
    NicknameSettingView(viewModel: LoginViewModel())
}
