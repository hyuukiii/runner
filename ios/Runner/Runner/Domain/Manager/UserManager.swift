//
//  UserManager.swift
//  Runner
//
//  Created by 윤현기 on 12/6/25.
//

import Foundation
import Combine


class UserManager: ObservableObject {
    static let shared = UserManager()
    
    // @AppStorage : 값이 바뀌면 화면도 자동으로 갱신되고 앱 꺼도 저장됨
    // "userId"라는 키로 저장. 기본 값은 -1 (로그인 안됨)
    @Published var currentUserId: Int {
        didSet {
            UserDefaults.standard.set(currentUserId, forKey: "userId")
        }
    }
    
    init() {
        self.currentUserId = UserDefaults.standard.integer(forKey: "userId")
        if self.currentUserId == 0 {self.currentUserId = -1 } // 값이 0이면 1로 초기화 하기
    }
    
    // 로그인 여부 확인
    var isLoggedIn: Bool {
        return currentUserId != -1
    }
    
    //로그아웃 (테스트용)
    func logut() {
        currentUserId = -1
    }
}
