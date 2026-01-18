//
//  BirthDateView.swift
//  Runner
//
//  Created by 윤현기 on 12/19/25.
//

import SwiftUI

struct BirthDateView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    // 기본값: 2000년 1월 1일
    @State private var birthDate: Date = {
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    private var dateRange: ClosedRange<Date> {
        let minDate = Calendar.current.date(from: DateComponents(year: 1900)) ?? Date()
        let maxDate = Date()
        return minDate ... maxDate
    }
        
    var body: some View {
        VStack(spacing: 0) {
            
            BackButtonHeader()
            
            // 메인 콘텐츠
            VStack(spacing: 0) {
                Spacer()
                
                // 공통 타이틀 사용
                OnboardingTitleView(
                    title: "생년월일을 알려주세요",
                    subTitle: "정확한 러닝 분석을 위해 필요해요"
                )
                .padding(.bottom, 30)
                
                // 날짜 피커
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.05))
                        .frame(height: 220)
                    
                    DatePicker(
                        "",
                        selection: $birthDate,
                        in: dateRange,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    .frame(maxHeight: 200)
                    .clipped()
                }
                .padding(.horizontal, 20)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // 하단 버튼 (공통 컴포넌트 적용)
            VStack {
                BottomStepButton(
                    title: "다음",
                    currentStep: 2,
                    isEnabled: true, // 항상 활성화
                    action: goNext
                )
            }
            
            .padding(.horizontal, 24)
            .padding(.bottom, 10)
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func goNext() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        let dateString = formatter.string(from: birthDate)
        viewModel.birthDate = dateString
        viewModel.navigationPath.append(.genderInfo)
    }
}
