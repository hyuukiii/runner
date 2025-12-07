//
//  LoginView.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//

import SwiftUI

struct LoginView: View {
    // 화면의 상태를 저장하는 변수들 (@State)
    @State private var email: String = ""
    @State private var code: String = ""
    @State private var isCodeSent: Bool = false // 인증번호 보냈는지 여부
    
    var body: some View {
            VStack(spacing: 20) {
                
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("RunMatch")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 40)
                
                // 1. 이메일 입력칸
                TextField("이메일을 입력해주세요", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    .disabled(isCodeSent) // 인증번호 보내면 수정 못하게 막음
                
                // 2. 인증번호 발송 버튼
                if !isCodeSent {
                    Button(action: {
                        // 서버로 이메일 전송 요청
                        APIManager.shared.sendVerificationCode(email: email.sanitizedEmail) { success in
                            
                            // UI 변경은 반드시 메인 스레드에서 해야 함
                            DispatchQueue.main.async {
                                if success {
                                    isCodeSent = true //화면을 인증번호 입력 모드로 변경
                                }
                            }
                        }
                        
                    }) {
                        Text("인증번호 받기")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                // 3. 인증번호 입력칸 (발송 성공 시에만 보임)
                if isCodeSent {
                    VStack(spacing: 15) {
                        TextField("인증번호 6자리", text: $code)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        
                        Button(action:  {
                            
                            // 서버로 인증번호 검증 요청
                            APIManager.shared.verifyCode(email: email.sanitizedEmail, code: code.sanitizedCode) { success in
                                if success {
                                    // 전역 관리자에게 알려주기 (ContentView가 이걸 보고 화면을 바꿈)
                                    UserManager.shared.currentUserId = 1
                                    print("로그인 성공 UserManager 업데이트 완료")
                                } else {
                                    // TODO: 인증실패 알림 UI 띄우기
                                    print("인증 실패 알림 띄우기")
                                }
                            }
                        }) {
                            Text("로그인 하기")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                
            Spacer()
        }
            .padding(.top, 50)
      }
        
   } //LoginView

#Preview {
    LoginView()
}
