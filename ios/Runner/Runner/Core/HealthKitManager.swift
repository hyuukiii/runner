//
//  HealthKitManager.swift
//  Runner
//
//  Created by 윤현기 on 11/30/25.
//

import Foundation
import HealthKit
import Combine // 데이터의 흐름, 변경 사항 감지, 신호 처리 등을 담당하는 "엔진"


// ObservableObject : (관찰 가능한 객체)
class HealthKitManager: ObservableObject {
    
    // HealthKit 저장소 (내부 DB 접근용)
    let healthStore = HKHealthStore()
    
    // 읽어올 데이터 종류 (거리, 칼로리, 심박수)
    // 읽기 권한은 많아도 되지만,  쓰기 권한은 신중해야 함
    let readTypes: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!, // 걷기 + 달리기 거리
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,     // 활동 칼로리
        HKObjectType.quantityType(forIdentifier: .heartRate)!               // 심박수
    ]
    
    // 권한 요청 함수 (해당 함수 UI에서 호출)
    func requestAuthorization() {
        
        // 1. 이 기기가 HelathKit을 지원하는지 확인(아이패드는 안 됨)
        guard HKHealthStore.isHealthDataAvailable() else {
            print("해당 기기는 HealthKit을 지원하지 않아요")
            return
        }
        
        
        // 2. 권한 요청 팝업 띄우기
        // toShare: nil (우린 읽기만 할 거니깐 쓰기 권한은 요청 안함)
        // read: 위에서 정의한 readTypes
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if success {
                print("HealthKit 권한승인 완료! 이제 데이터를 읽어 올게요")
            } else {
                print("권한 요청 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
            }
        }
    }
}
