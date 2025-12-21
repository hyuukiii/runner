//
//  GenderView.swift
//  Runner
//
//  Created by 윤현기 on 12/21/25.
//

import SwiftUI

struct GenderView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    // UI용 성별 열거형 ( 내부에서만 사용 )
    enum GenderOption: String, CaseIterable {
        case male = "남성"
        case female = "여성"
        
        // 서버 전송용 값 ( DTO 형식에 맞추기 )
        var serverValue: String {
            switch self {
            case .male: return "MALE"
            case .female: return "FEMALE"
            }
        }
    }
    
    // 선택된 성별 (nil이면 선택 안함)
    @State private var selectedGender: GenderOption? = nil
    // MARK: - UI코드
    var body: some View {
        VStack(spacing: 0) {
            
            BackButtonHeader()
            
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            VStack(spacing: 40) {
                
                // 2. 타이틀
                VStack(spacing: 10) {
                    Text("성별을 선택해주세요")
                        .font(.system(size: 26, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                    
                    Text("러닝 데이터 분석에 활용 돼요")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
                
                Spacer()
                
                // 성별 선택 카드 ( HStack으로 나란히 )
                HStack(spacing: 15) {
                    ForEach(GenderOption.allCases, id: \.self) { gender in
                        GenderCard(
                            gender: gender,
                            isSelected: selectedGender == gender
                        ) {
                            // 탭 했을 떄 동작
                            withAnimation(.spring(response: 0.3,dampingFraction: 0.7)) {
                                selectedGender = gender
                                HapticManager.instance.impact(style: .medium) // 톡! 하는 진동
                            }
                        }
                    }
                } // GenderCard HStack
                .padding(.horizontal, 20)
                
                Spacer()
                
            } // 최상위 부모 VStack
            .padding(.horizontal, 24)
            
            // 하단버튼 ( 가입 완료 )
            VStack {
                Button(action: { finishJoin() }) {
                    HStack(spacing:8) {
                        Text("가입 완료")
                            .font(.headline).fontWeight(.bold)
                        Text("3 / 3")
                            .font(.subheadline).opacity(0.7)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(selectedGender != nil ? Color.blue : Color.gray.opacity(0.3))
                    .cornerRadius(16)
                    .shadow(color: selectedGender != nil ? Color.blue.opacity(0.3) : Color.clear, radius: 10, x:0, y:5)
                }
                .disabled(selectedGender == nil) // 선택 안 하면 못 넘어감
            } // 자식 VStack
            .padding(.horizontal, 24)
            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // 가입 요청 로직
    private func finishJoin() {
        guard let gender = selectedGender else { return }
        
        // 뷰모델에 성별 저장
        viewModel.gender = gender.serverValue
        
        print("최종 데이터 확인: \(viewModel.email), \(viewModel.nickname), \(viewModel.birthDate), \(viewModel.gender)")
        
        // 서버 통신 요청(LoginViewMopdel에 함수가 있다고 가정)
        // viewModel.requestJoin()
    }
}

// MARK: - 성별 선택 카드 컴포넌트
struct GenderCard: View {
    let gender: GenderView.GenderOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                // 아이콘 (figure.stand로 변경 가능)
                Image(systemName: gender == .male ? "face.smiling.fill" : "face.smiling.fill")
                    .font(.system(size: 40))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(gender.rawValue)
                    .font(.headline)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity) // 가로 꽉 채우기
            .frame(height: 160) // 높이 고정
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue.opacity(0.05) : Color.white) // 선택 시 연한 파랑 배경
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.1), lineWidth: isSelected ? 2 : 1.5)
            )
            // 선택 시 약간 커지는 효과
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle()) // 버튼 깜빡임 효과 제거
        
    } // body
} // GenderCard

#Preview {
    GenderView(viewModel: LoginViewModel())
}
