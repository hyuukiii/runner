//
//  HapticManager.swift
//  Runner
//
//  Created by 윤현기 on 12/17/25.
//

import UIKit

class HapticManager {
    static let instance = HapticManager()
    
    // 알림 진동 (성공, 에러, 경고)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    // 터치 진동 ( 가벼운 터치감 )
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
