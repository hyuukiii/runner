//
//  LoginStep.swift
//  Runner
//
//  Created by 윤현기 on 12/7/25.
//

// 화면 단계 정의 (이메일 입력 -> 코드 입력 -> 헬스킷 -> 내 위치 -> 닉네임)
enum LoginStep {
    case email
    case codeInput
    case healthAuth
    case locationSetting
    case nickname
    case genderInfo
}
