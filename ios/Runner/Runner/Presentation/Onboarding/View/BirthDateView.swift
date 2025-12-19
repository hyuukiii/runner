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
    
    // 1. 선택된 날짜 ( 기본값: 2000년 1월 1일)
    // ?? : 왼쪽 값이 없으면(nil), 오른쪽 값을 써라!
    @State private var birthDate: Date = {
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    // 2. 날짜 범위 설정
    // 미래의 날짜는 선택 못하게 막아야 함
    private var dateRange: ClosedRange<Date> {
        let minDate = Calendar.current.date(from: DateComponents(year: 1900)) ?? Date()
        let maxDate = Date()
        
        return minDate...maxDate
    }
}
    
    
    
    
    
#Preview {
    BirthDateView(viewModel: LoginViewModel())
}
