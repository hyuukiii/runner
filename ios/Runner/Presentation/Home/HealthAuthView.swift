//
//  HealthAuthView.swift
//  Runner
//
//  Created by 윤현기 on 12/6/25.
//

import SwiftUI

struct HealthAuthView: View {
    // 1. 우리가 만든 매니저를 화면에 호출하자
    // 스위프트는 데이터가 바뀌면 계속 새로 화면을 그린다.
    // @StateObject :화면이 아무리 다시 그려져도, 헬스킷 매니저는 메모리에서 지우지 말고 유지 한다.
    @StateObject var hkManager = HealthKitManager()
    
    var body: some View {
        VStack(spacing: 20) {
            //로고 이미지
            Image(systemName: "heart.text.square.fill") // 애플 무료 아이콘(SF Symbols)
                .resizable()                            // SF Symbols는 글자 취급을 받아 크기가 고정, 이미지 크기를 바꿀려면 필수
                .frame(width: 80, height: 80)           // 아이콘 크기 조절
                .foregroundColor(.red)                  // 아이콘 색상 바꾸기
            
            Text("RunMatch")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("러닝 기록을 연동하고 \n나와 맞는 러너를 찾아봐요")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            // 2. 버튼을 누르면 헬스킷 매니저에 적용한 코드를 호출한다.
            Button(action: {
                hkManager.requestAuthorization()
            }) {
                Text("건강앱과 빠르게 연동 하세요!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    HealthAuthView()
}
