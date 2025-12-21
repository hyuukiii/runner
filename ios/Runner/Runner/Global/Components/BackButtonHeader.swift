//
//  BackButtonHeader.swift
//  Runner
//
//  Created by 윤현기 on 12/21/25.
//

import SwiftUI

struct BackButtonHeader: View {
    // 스스로 닫기 기능을 가짐
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    // 터치 영역 확보를 위해 패딩을 투명하게 줌 (UX 디테일)
                    .padding(10)
            }
            // 버튼 자체 패딩 때문에 왼쪽으로 쏠리는 것 보정
            .padding(.leading, -10)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }
}

#Preview {
    BackButtonHeader()
}
