//
//  OnboardingViewModel.swift
//  Runner
//
//  Created by 윤현기 on 12/6/25.
//

//import Foundation
//import AuthenticationServices
//import Combine
//
//
//class OnboardingViewModel: ObservableObject {
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//    @Published var isLoggedIn: Bool = false
//    
//    /**
//        애플 로그인 성공 시 호출 될 함수
//     */
//    func handleAppleLogin(result: Result<ASAuthorization, Error>) {
//        switch result {
//        case .success(let authorization):
//            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                
//                let userIdentifier = appleIDCredential.user
//                let email = appleIDCredential.email
//                let fullName = appleIDCredential.fullName
//                
//                print(" 애플 로그인 성공 ID: \(userIdentifier)")
//                
//                // TODO: 여기서 백엔드 서버 API 호출 (로그인/가입)
//                // 지금은 임시로 성공 처리
//                self.loginSuccess(tempUserId : 999)
//            }
//            
//        case .failure(let error) :
//            print("로그인 실패 : \(error.localizedDescription)")
//        }
//    }
//    
//    //로그인 성공 처리
//    private func loginSuccess(tempUserId : Int) {
//        UserManager.shared.currentUserId = tempUserId
//        self.isLoggedIn = true
//    }
//}
