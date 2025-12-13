//
//  ContentView.swift
//  Runner
//
//  Created by 윤현기 on 11/29/25.
// 화면을 그리는 View가 아닌 로그인 여부에 따라 어느 화면을 보여줄지 결정만 함

import SwiftUI

struct ContentView: View {
    @StateObject var userManager = UserManager.shared
    
    var body: some View {
        //분기 처리
        if userManager.isLoggedIn {
            // 1. 로그인이 되어 있다면 -> 매칭화면으로
            MatchingView()
        } else {
            // 2. 로그인이 안 되어 있다면 -> '로그인 플로우'로
            LoginFlowView()
        }
    }
}
    
#Preview {
    ContentView()
}
