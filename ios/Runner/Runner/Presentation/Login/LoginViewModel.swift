//
//  LoginViewModel.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    // 입력 데이터
    @Published var email: String = ""
    @Published var code: String = ""
    
    // 화면 이동 경로 (이 배열에 값을 넣으면 화면이 바뀜)
    @Published var navigationPath: [LoginStep] = []
    
    /**
      * 이메일 전송
     **/
    func sendCode() {
        // 이메일 소문자로 변경
        let cleanEmail = email.sanitizedEmail
        
        // TODO: 로딩 표시 띄우기
        
        APIManager.shared.sendVerificationCode(email: cleanEmail) {success in
            DispatchQueue.main.async {
                if success {
                    //성공하면 경로에 '코드입력' 단계를 추가 -> 화면이 스와이프 형태로 넘어감
                    self.navigationPath.append(.codeInput)
                } else {
                    print("이메일 전송 실패 알림")
                }
            }
        }
    } // sendEmail
    
    /**
      * 코드 검증 (성공하면 true 반환)
     **/
    func verifyCode() {
        let cleanEmail = email.sanitizedEmail
        let cleanCode = code.sanitizedCode
        
        APIManager.shared.verifyCode(email: cleanEmail, code: cleanCode) {success in
            DispatchQueue.main.async {
                if success {
                    //로그인 성공 -> 건강앱 연동 화면으로 이동
                    self.navigationPath.append(.healthAuth)
                } else {
                    print("인증번호 불일치 알림")
                    // 실패하면 입력한 코드 지워주기
                    self.code = ""
                }
            }
        }
    } // verifyCode
    
} // class
