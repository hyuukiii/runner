//
//  OnboardingView.swift
//  Runner
//
//  Created by 윤현기 on 12/6/25.
//

//import Foundation
//import SwiftUI
//import AuthenticationServices
//
//struct OnboardingView: View {
//    // 1. ViewModel 연결
//    @StateObject private var viewModel = OnboardingViewModel()
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//        
//        Image(systemName: "figure.run.circle.fill")
//            .resizable()
//            .frame(width: 100, height: 100)
//            .foregroundColor(.blue)
//        
//        Text("RunMatch")
//            .font(.largeTitle)
//            .fontWeight(.heavy)
//        
//        Text("복잡한 입력 없이\nApple 계정으로 3초 만에 시작하세요.")
//            .multilineTextAlignment(.center)
//            .foregroundColor(.gray)
//    
//        Spacer()
//    
//        // 2. 버튼 로직을 ViewModel로 위임하지 않고, 클로저에서 바로 넘김
//        SignInWithAppleButton(
//            onRequest : { request in
//                request.requestedScopes = [.fullName, .email]
//            },
//            onCompletion: { result in
//                // 결과 처리를 ViewModel에게 통째로 넘김
//                viewModel.handleAppleLogin(result: result)
//            }
//        )
//        .signInWithAppleButtonStyle(.black)
//        .frame(height: 50)
//        .padding(.horizontal)
//    
//        // 3. 에러 메시지 바인딩
//        if let error = viewModel.errorMessage {
//            Text(error).foregroundColor(.red).font(.caption)
//        }
//        
//        Spacer().frame(height: 50)
//    }
//        .padding()
//        
//        // 4. 로딩 중이면 화면 가리기 (옵션)
//        .overlay {
//            if viewModel.isLoading {
//                ProgressView().controlSize(.large)
//            }
//        }
//    }
//}
//
//#Preview {
//    OnboardingView()
//}

