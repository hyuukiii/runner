//
//  NicknameSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/16/25.
// TODO: 다음 버튼에 1 / 3 기능 넣기 , 닉네임 입력칸 허전해서 UI/UX 적으로 개선하기 , 유효성 검사 로직은 실행 될 때만 보여주기

import SwiftUI

struct NicknameSettingView: View {
    // 이전 화면(LoginFlow)에서 주입받을 뷰모델
    @ObservedObject var viewModel: LoginViewModel
    
    // 뒤로가기 동작을 위해 환경변수 추가 (UI에서는 보이지 않음)
    @Environment(\.dismiss) private var dismiss
    
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
                Text("어떤 닉네임으로\n불러드릴까요?")
                    .font(.system(size: 26, weight: .bold))
                    .lineSpacing(4) // 줄 간격 살짝 띄우기
                
                Text("러닝 메이트들에게 보여질 이름 이에요")
                    .font(.body)
                    .foregroundColor(.gray)
                
            } // 안내 문구 VStack
            .padding(.top, 40)
            
            // 2. 닉네임 입력창
            VStack(alignment: .leading,spacing: 8) {
                
                // HStack 닉네임 입력칸
                HStack {
                    TextField("닉네임 입력", text: $nickname)
                        .font(.title2)
                        .focused($isFocused) // 화면 켜지면 바로 포커스됨
                        .onChange(of: nickname) { newValue in
                            // 공백 제거 및 글자 수 10자 제한
                            let filtered = newValue.replacingOccurrences(of: " ", with: "")
                            if filtered.count > 10 {
                                nickname = String(nickname.prefix(10))
                            } else {
                                nickname = filtered
                            }
                        }
                    // 입력 내용이 있을 때 X 버튼 표시
                    if !nickname.isEmpty {
                        Button(action: {
                            nickname = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                    }
                }
                .padding(.vertical, 10)
                
                // 밑줄 디자인
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isValid ? .blue : .gray.opacity(0.3))
                
                // 하단 헬퍼 텍스트 ( 에러 메시지 or 글자수 카운트 )
                HStack {
                    if !nickname.isEmpty && nickname.count < 2 {
                        Text("2글자 이상 가능해요")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Spacer()
                    }
                    
                    // 글자 수 표시 (1/10)
                    Text("\(nickname.count) / 10")
                        .font(.caption)
                        .foregroundColor(isValid ? .gray : .gray.opacity(0.5))
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 24)
            
            Spacer()
            
            //3. 다음 버튼 ( 1/3 단계 표시 추가 )
            Button(action: {
                goNext()
            }) {
                HStack(spacing: 15) {
                    Text("다음")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    // 단계 표시 (1/3)
                    Text("1 / 3")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .opacity(0.6) // 살짝 투명하게 해서 '다음' 글자 강조하기
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(isValid ? Color.blue : Color.gray.opacity(0.3)) // 비활성화 시 회색
                .cornerRadius(16)
            }
            .disabled(!isValid) // 유효하지 않으면 클릭 불가
            .padding(.horizontal, 24)
            .padding(.bottom, 10) // 키보드 올라오면 자동으로 위치 조정됨 (키보드 위 여백)
        }
        .onAppear {
            // 화면 진입 시 0.5초 뒤 키보드 올리기 (자연스러운 UX)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
            // 네비게이션 바 커스텀 하기
            .navigationBarBackButtonHidden(true) // 기본 버튼 숨기기
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // 뒤로가기 로직
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.leading, 8)
                    }
                }
            }
        } // 부모 VStack
        
        // 다음 화면으로 이동
        private func goNext() {
            
            // 뷰모델에 닉네임 저장
            viewModel.nickname = nickname
                    
            // 다음 단계(성별/나이)로 네비게이션 이동
            viewModel.navigationPath.append(.genderInfo)
        }
    }


// 프리뷰
#Preview {
    NicknameSettingView(viewModel: LoginViewModel())
}
