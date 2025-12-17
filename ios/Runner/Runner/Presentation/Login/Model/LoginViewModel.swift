//
//  LoginViewModel.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//
import SwiftUI
import Combine
import UIKit // UIImage 사용을 위해 추가

class LoginViewModel: ObservableObject {
    // 입력 받은( 받아야할 ) 데이터
    @Published var email: String = ""
    @Published var code: String = ""
    @Published var region: String = ""
    @Published var nickname: String = ""
    @Published var gender: String = ""
    @Published var birthYear: Int = 0
    
    // 프로필 이미지 저장 변수
    @Published var profileImage: UIImage? = nil
    
    @Published var navigationPath: [LoginStep] = [] // 화면 이동 경로 (이 배열에 값을 넣으면 화면이 바뀜)
    
    // 부가적 기능
    @Published var errorMessage: String = "" // 에러 메시지 저장용 변수
    @Published var showError: Bool = false  // 에러 메시지 보여줄지 말지 결정
    @Published var shakeTrigger: Int = 0
    @Published var isLoading: Bool = false // 로딩 상태 변수
    
    /**
      * 이메일 형식 검사 하는 정규식 함수
     */
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /**
      * 이메일 전송
     **/
    func sendCode() {
        // 이메일 소문자변환
        let cleanEmail = email.sanitizedEmail
        if !isValidEmail(cleanEmail) {
            errorMessage = "이메일을 다시 확인해주세요"
            showError = true
            shakeTrigger += 1 // 좌우로 흔듦
            return
        }
        
        // 로딩화면으로 전환
        // withAnimation : 화면이 부드럽게 페이드인/아웃 됨
        withAnimation {
            isLoading = true
            showError = false
        }
            
        // 2. 서버 전송
        APIManager.shared.sendVerificationCode(email: cleanEmail) {success in
            DispatchQueue.main.async {
                // 로딩 종료 (약간의 딜레이를 줘서 빨리 깜빡이는것을 방지함) 만약 서버가 너무 빠르면 0.5초정도 보여기
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        self.isLoading = false
                    }
                }
                
                if success {
                    self.showError = false // 성공 시 에러 false
                    self.navigationPath.append(.codeInput) // 성공하면 경로에 '코드입력' 단계를 추가 -> 화면이 스와이프 형태로 넘어감
                } else {
                    self.errorMessage = "잠시 후 다시 시도해주세요"
                    self.showError = true
                    self.shakeTrigger += 1
                }
            }
        }
    } // sendCode
    
    /**
      * 코드 검증 (성공하면 true 반환)
     **/
    func verifyCode() {
        let cleanEmail = email.sanitizedEmail
        let cleanCode = code.sanitizedCode
        
        APIManager.shared.verifyCode(email: cleanEmail, code: cleanCode) {success in
            DispatchQueue.main.async {
                if success {
                    self.showError = false
                    self.navigationPath.append(.healthAuth) // 로그인 성공 -> 건강앱 연동 화면으로 이동
                } else {
                    self.errorMessage = "인증코드를 확인해주세요"
                    self.showError = true
                    self.code = ""// 실패하면 입력한 코드 지워주기
                    self.shakeTrigger += 1
                }
            }
        }
    } // verifyCode
    
} // class
