//
//  EmailInputView.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
// 이메일 입력 플로우 화면

import SwiftUI

struct EmailInputView: View {
    @ObservedObject var viewModel: LoginViewModel
    @FocusState private var isFocused: Bool //키보드 자동 띄우기용
    
    var body: some View {
        VStack(alignment: .leading, spacing:20) {
            
            // 타이틀
            Text("이메일을\n입력해주세요")
                .font(.system(size: 26, weight: .bold))
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            //입력창
            TextField("example@example.com", text: $viewModel.email)
                .textFieldStyle(.plain)
                .font(.system(size: 20))
                .padding(.vertical, 10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .focused($isFocused) // 화면 켜지면 여기에 포커스
                .onSubmit { viewModel.sendCode() } // 키보드에서 '완료/Go' 누르면 바로 전송
                .onChange(of: viewModel.email) { _ in
                    viewModel.showError = false // 글자 입력 시 에러 메시지 OFF
                }
            
            // 에러 메시지 (조건부 표시)
            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, 5)
                    .transition(.opacity) // 부드럽게 표시
            }
            
            Spacer()
            
            // 다음 버튼 (키보드 위에 붙어있는 느낌)
            Button(action: {
                viewModel.sendCode()
            }) {
                Text("다음")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.email.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(viewModel.email.isEmpty)
        }
        .padding(.horizontal, 24)
        .onAppear {
            // 화면 뜨자마자 키보드 올리기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
    }
}
