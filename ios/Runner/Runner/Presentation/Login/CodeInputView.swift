//
//  CodeInputView.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//  인증코드 플로우 화면단
//  자동 넘김 기능 .onChange를 써서 6자리가 되는 순간 버튼 누를 필요 없이 서버로 전송

import SwiftUI

struct CodeInputView: View {
    @ObservedObject var viewModel: LoginViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("인증번호 6자리를\n입력해주세요")
                .font(.system(size: 26, weight: .bold))
                .padding(.top, 40)
            
            Text("\(viewModel.email)로 보냈어요")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // 6칸 입력 박스 ZStack으로 한번 감싸기
            ZStack {
                TextField("", text: $viewModel.code)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .accentColor(.clear) // 커서 숨기기
                    .foregroundColor(.clear) // 바디 부분의 글자 투명하게 만들어서 숨기기
                    .onChange(of: viewModel.code) { newValue in // 글자가 바뀔 때 마다 감시하기
                        if !newValue.isEmpty {
                            viewModel.showError = false
                        }
                    
                        // 6자리가 되면 자동으로 검증 요청
                        if newValue.count == 6 {
                            viewModel.verifyCode()
                        }
                        
                        // 6자리 넘어가면 잘라버림
                        if newValue.count > 6 {
                            viewModel.code = String(newValue.prefix(6))
                        }
                    }
                
                // 2. 6개 박스 디자인
                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(getBorderColor(index: index), lineWidth: 2) //테두리 색상 로직
                            .frame(width: 45, height: 55)
                            .background(Color.gray.opacity(0.05))
                            .overlay(
                                Text(getChar(at: index))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            )
                    }
                }
            }
            .padding(.top, 20)
            
            // 에러 메세지
            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center) // 가운데 정렬
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            isFocused = true
        }
    }
    
    // ====================== 헬퍼 함수들 ======================
    
        /**
          * n번째 글자 가져오기
        **/
        private func getChar(at index: Int) -> String {
            if index < viewModel.code.count {
                let stringIndex = viewModel.code.index(viewModel.code.startIndex, offsetBy: index)
                return String(viewModel.code[stringIndex])
            }
            return ""
        }
    
        /**
          * 테두리 색상 결정 (입력 중인 칸은 파란색, 에러나면 빨간색)
        **/
        private func getBorderColor(index: Int) -> Color {
            if viewModel.showError {
                return .red // 에러나면 전체 빨강
            }
            if index == viewModel.code.count {
                return .blue // 현재 입력해야 할 칸은 파랑
            }
            return .gray.opacity(0.3) // 나머지는 회색
        }
    }
