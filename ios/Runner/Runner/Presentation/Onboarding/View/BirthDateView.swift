//
//  BirthYearView.swift
//  Runner
//
//  Created by 윤현기 on 12/19/25.
//

//
//  BirthYearView.swift
//  Runner
//
//  Created by 윤현기 on 12/19/25.
//

import SwiftUI

struct BirthDateView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    
    // 선택된 날짜 ( 기본값 : 2000년 1월 1일 )
    @State private var birthDate: Date = {
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    // 날짜 범위 설정 ( 1900 ~ 오늘 )
    // 미래의 날짜는 선택 못하게 막아야 함
    private var dateRange: ClosedRange<Date> {
        let minDate = Calendar.current.date(from: DateComponents(year: 1900)) ?? Date()
        let maxDate = Date()
        return minDate ... maxDate
    }
        
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 상단 네비게이션
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            VStack(spacing : 40) {
                
                //타이틀
                VStack(spacing: 10) {
                    Text("생년월일을 알려주세요")
                        .font(.system(size: 26, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                    
                    Text("정확한 러닝 분석을 위해 필요해요")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
                
                Spacer()
                
                // 지역 설정에 따라 ' 년/월/일 ' 순서가 자동으로 바뀝니다.
                ZStack {
                    // 배경 깔아주기 ( 선택 영역 강조 )
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.05))
                        .frame(height: 200) // 피커 높이보다 살짝 크게
                    
                    DatePicker(
                        "",
                        selection: $birthDate,
                        in: dateRange, // 미래 날짜 선택 불가
                        displayedComponents: [.date] // 날짜만 표시(시간 제외)
                    )
                    .datePickerStyle(.wheel) // 휠 스타일
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR")) // 한국어 형식 강제 ( 선택사항 )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // 하단 버튼
            VStack {
                Button(action: { goNext() }) {
                    HStack(spacing: 8) {
                        Text("다음")
                            .font(.headline).fontWeight(.bold)
                        Text("2 / 3") // 단계 표시
                            .font(.subheadline).opacity(0.7)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.blue)
                    .cornerRadius(16)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
            }
            .navigationBarBackButtonHidden(true)
        }
    
        private func goNext() {
            // 1. 날짜 형식을 지정해주는 포멧터 생성
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" // 서버랑 약속한 상태 ( 대소문자 중요 )
            formatter.locale = Locale(identifier: "ko_KR")
            
            // 2. Date 객체 -> 1991-01-01 문자열로 변환
            let dateString = formatter.string(from: birthDate)
            
            // 3. 뷰모델에 저장
            viewModel.birthDate = dateString
            
            print("서버로 보낼 생년월일 : \(dateString)") // 디버깅
            
            viewModel.navigationPath.append(.genderInfo)
        }
}
    
#Preview {
    BirthDateView(viewModel: LoginViewModel())
}
