//
//  RunnerBibView.swift
//  Runner
//
//  Created by 윤현기 on 12/19/25.
//

//
//  RunnerBibView.swift
//  Runner
//
//  Created by 윤현기 on 12/19/25.
//

import SwiftUI
import PhotosUI

struct RunnerBibView: View {
    // 1. 데이터 바인딩
    @Binding var nickname: String
    var image: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    
    // 2. 🔥 핵심: 부모 뷰와 포커스 상태를 공유하기 위해 Binding 사용
    @FocusState.Binding var isFocused: Bool
    
    // 3. 이미지 변경 이벤트 클로저
    var onImageChange: (Data) -> Void
    
    var body: some View {
        ZStack {
            // 종이 느낌의 배경
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .frame(width: 280, height: 340)
            
            // 러너 카드 끝쪽 4부분의 구멍 UI
            VStack {
                HStack { Circle().frame(width: 12); Spacer(); Circle().frame(width: 12) }
                Spacer()
                HStack { Circle().frame(width: 12); Spacer(); Circle().frame(width: 12) }
            }
            .foregroundColor(Color.gray.opacity(0.2))
            .padding(15)
            .frame(width: 280, height: 340)
            
            // 내용물
            VStack(spacing: 20) {
                Text("RUNNING MATE")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.gray.opacity(0.5))
                    .tracking(2)
                
                // 프로필 사진 UI
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.1), lineWidth: 1))
                        } else {
                            ZStack {
                                Circle().fill(Color.gray.opacity(0.05))
                                Circle().strokeBorder(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.blue.opacity(0.5))
                            }
                            .frame(width: 120, height: 120)
                        }
                    }
                    .frame(width: 120, height: 120)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            onImageChange(data)
                        }
                    }
                }
                
                // 러너 카드 내부의 닉네임 입력하는 곳 (RUNNER)
                VStack(spacing: 4) {
                    TextField("RUNNER", text: $nickname)
                        .font(.system(size: 40, weight: .heavy)) // 배번표 폰트
                        .multilineTextAlignment(.center) // 가운데 정렬
                        .focused($isFocused) // 🔥 바인딩된 포커스 연결
                        .textInputAutocapitalization(.characters) // 자동 대문자
                        .foregroundColor(.black)
                        .tint(.blue) // 커서 색상
                        .frame(height: 50)
                        .minimumScaleFactor(0.5)
                }
                
                // 바코드 UI
                HStack(spacing: 4) {
                    ForEach(0..<15) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.8))
                            .frame(width: CGFloat.random(in: 2...12), height: 20)
                    }
                }
                .opacity(0.3)
            }
            .padding(.vertical, 30)
            .frame(width: 280)
        }
    }
}
