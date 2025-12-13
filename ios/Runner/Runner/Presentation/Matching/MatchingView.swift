//
//  MatchingView.swift
//  Runner
//
//  Created by 윤현기 on 12/13/25.
//

import SwiftUI

struct MatchingView: View {
    var body: some View {
        VStack {
            Text("여기가 매칭 화면입니다! 🏃‍♂️")
                .font(.largeTitle)
            Text("나와 딱 맞는 러너를 찾아보세요")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    MatchingView()
}
