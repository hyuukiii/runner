//
//  CodeInputView.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
// 자동 넘김 기능 .onChange를 써서 6자리가 되는 순간 버튼 누를 필요 없이 서버로 전송

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
            
            TextField("123456", text: $viewModel.code)
                .textFieldStyle(.plain)
                .font(.system(size: 24, weight: .bold)) // 숫자니까 더 크게
                .keyboardType(.numberPad)
                .focused($isFocused)
                // 글자가 바뀔 때 마다 감시하기
                .onChange(of: viewModel.code) { newValue in
                    // 6자리가 되면 자동으로 검증 요청
                    if newValue.count == 6 {
                        viewModel.verifyCode()
                    }
                    // 6자리 넘어가면 잘라버림
                    if newValue.count > 6 {
                        viewModel.code = String(newValue.prefix(6))
                    }
                }
            
            Spacer()
            
            // 버튼이 있긴 하지만, 자동이라서 누를 일은 거의 없음
            // (혹시 모를 수동 제출용)
            if viewModel.code.count == 6 {
                Button(action: {
                    viewModel.verifyCode()
                }) {
                    Text("확인")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal, 24)
        .onAppear {
            isFocused = true
        }
    }
}

