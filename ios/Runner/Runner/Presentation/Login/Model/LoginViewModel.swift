//
//  LoginViewModel.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//
import SwiftUI
import Combine
import UIKit // UIImage 사용을 위해 추가

@MainActor
class LoginViewModel: ObservableObject {
    // 입력 받은( 받아야할 ) 데이터
    @Published var email: String = ""
    @Published var code: String = ""
    @Published var region: String = ""
    @Published var nickname: String = ""
    @Published var gender: String = ""
    
    // 문자열string 에서 -> 서버로 보낼 2000-01-01 형태로 변경
    @Published var birthDate: String = ""
    
    // 애플 로그인 구현 전까지 사용할 임시 ID
    @Published var appleUserId: String = UUID().uuidString;
    
    // 프로필 이미지 저장 변수
    @Published var profileImage: UIImage? = nil
    
    @Published var navigationPath: [LoginStep] = [] // 화면 이동 경로 (이 배열에 값을 넣으면 화면이 바뀜)
    
    // 부가적 기능
    @Published var errorMessage: String = "" // 에러 메시지 저장용 변수
    @Published var showError: Bool = false  // 에러 메시지 보여줄지 말지 결정
    @Published var shakeTrigger: Int = 0
    @Published var isLoading: Bool = false // 로딩 상태 변수
    
    // MARK: 회원가입 API 호출
    func requestJoin() async -> Bool {
        
        self.isLoading = true; // 로딩 뷰 시작
        defer { self.isLoading = false } // 함수가 끝날 떄 무조건 로딩 종료 하기
        
        // 요청 할 URL (시뮬레이션용 : 로컬 호스트)
        guard let url = URL(string: "http://localhost:8080/users/join") else {
            print("잘못된 URL");
            return false;
        }
        
        // Request 설정
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        
        // 멀티파트 바운더리( 경계선 ) 생성
        let boundary = UUID().uuidString;
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
        
        var body = Data();
        
        let jsonDict: [String: Any] = [
            "appleUserId" : self.appleUserId,
            "nickname" : self.nickname,
            "email": self.email,
            "gender" : self.gender,
            "birthDate" : self.birthDate,
            "region" : self.region
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"request\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            body.append(jsonData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        if let image = self.profileImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profileImage\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // 바운더리 종료
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // 서버 통신 시작
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else { return false }
            
            if(200...299).contains(httpResponse.statusCode) {
                let responseString = String(data : data, encoding: .utf8) ?? ""
                print("회원가입 성공")
                return true
            } else {
                print("서버 에러 : 상태코드\(httpResponse.statusCode)");
                let errorString = String(data: data, encoding: .utf8) ?? ""
                print("에러 내용: \(errorString)")
                return false
            }
                
        } catch {
            print("통신 실패 : \(error.localizedDescription)")
            return false
        }
        
    }
    
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
