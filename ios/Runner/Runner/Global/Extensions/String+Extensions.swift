//
//  String+Extensions.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//

import Foundation

extension String {
    // 연산 프로퍼티 (변수처럼 씀)
    // 사용법 : email.sanitizedEmail
    var sanitizedEmail: String {
        return self.trimmingCharacters(in: .whitespaces).lowercased()
    }
    
    
    var sanitizedCode: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
