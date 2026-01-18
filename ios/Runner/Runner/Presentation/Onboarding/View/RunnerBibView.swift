//
//  RunnerBibView.swift
//  Runner
//
//  Created by 윤현기 on 12/19/25.
//

import SwiftUI
import PhotosUI

struct RunnerBibView: View {
    @Binding var nickname: String
    var image: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    @FocusState.Binding var isFocused: Bool
    var onImageChange: (Data) -> Void
    
    // 카드 고정 크기 정의
    private let cardWidth: CGFloat = 230
    private let cardHeight: CGFloat = 280
    
    var body: some View {
        ZStack {
            // 배경 (높이 적용)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .frame(width: cardWidth, height: cardHeight)
            
            // 2. 모서리 구멍 디테일
            VStack {
                HStack { Circle().frame(width: 12); Spacer(); Circle().frame(width: 12) }
                Spacer()
                HStack { Circle().frame(width: 12); Spacer(); Circle().frame(width: 12) }
            }
            .foregroundColor(Color.gray.opacity(0.2))
            .padding(15)
            .frame(width: cardWidth, height: cardHeight)
            
            // 3. 콘텐츠 (간격 조정)
            // 내부 요소 간격을 20에서 15로 줄여서 공간 절약
            VStack(spacing: 15) {
                Text("RUNNING MATE")
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(.gray.opacity(0.5))
                    .tracking(2)
                    .padding(.top, 5) // 상단에 살짝 여백 추가
                
                // 사진 피커
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
                                Circle().strokeBorder(
                                    Color.gray.opacity(0.3),
                                    style: StrokeStyle(lineWidth: 2, dash: [6, 6])
                                )
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.blue.opacity(0.5))
                            }
                            .frame(width: 120, height: 120)
                        }
                    }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            onImageChange(data)
                        }
                    }
                }
                
                // 닉네임 입력 필드
                VStack(spacing: 4) {
                    TextField("RUNNER", text: $nickname)
                        .font(.system(size: 25, weight: .heavy))
                        .multilineTextAlignment(.center)
                        .focused($isFocused)
                        .textInputAutocapitalization(.characters)
                        .disableAutocorrection(true)
                        .foregroundColor(.black)
                        .tint(.blue)
                        .frame(height: 50)
                        .minimumScaleFactor(0.5)
                }
                .padding(.horizontal, 20)
                
                // 하단 바코드
                HStack(spacing: 4) {
                    ForEach(0..<15) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.8))
                            .frame(width: CGFloat.random(in: 2...12), height: 20)
                    }
                }
                .opacity(0.3)
                .padding(.bottom, 5) // 하단에 살짝 여백 추가
            }
            // 불필요한 추가 패딩 없음
            .frame(width: cardWidth)
        }
    }
}
