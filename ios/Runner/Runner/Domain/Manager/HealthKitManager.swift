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
    
    // HealthKit 저장소 내부 DB 접근용
    let healthStore = HKHealthStore()
    
    // 읽어올 데이터 종류 (거리, 칼로리, 심박수)
    // 읽기 권한은 많아도 되지만,  쓰기 권한은 신중해야 함
    let readTypes: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!, // 걷기 + 달리기 거리
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,     // 활동 칼로리
        HKObjectType.quantityType(forIdentifier: .heartRate)!               // 심박수
    ]
    
    /**
           헬스킷 권한 요청 함수 (해당 함수 UI에서 호출)
    **/
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
                print("HealthKit 권한승인 완료!")
                
                // 승인되자마자 바로 데이터 가져오기
                self.fetchRunningStats()
                
            } else {
                print("권한 요청 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
            }
        }
    }
    
    /**
            3개월 전 ~ 오늘 까지의 실제  러닝데이터 불러오기
     **/
    func fetchRunningStats() {

        // guard : 걷기 달리기 거리 데이터 타입 확인
        // 옵셔녈 바인딩 : 값이 nil인지 아닌지 확인 --> 가져오지 못하면 return
        guard let runningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
        
        // 3개월 전부터 ~ 오늘까지 날짜 정하기
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -3, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        // 쿼리 만들기 (통계)
        let query = HKStatisticsQuery(quantityType: runningType, quantitySamplePredicate: predicate, options: .cumulativeSum) {_, result, error in
            
            // 1. 쿼리를 만들고 건강앱에 보낼 때 에러가 있는지 먼저 확인
            if let error = error {
                print("쿼리 에러 발생 : \(error.localizedDescription)")
                return
            }
            
            let sum = result?.sumQuantity()
            let distance = sum?.doubleValue(for: HKUnit.meter()) ?? 0.0
            
            print("아이폰 측정 거리: \(distance) 미터")
            
            // 서버로 전송하기
            // 유저 ID 1번으로 보냄(포스트맨으로 만들었던 유저임)
            APIManager.shared.uploadRunningRecord(userId: 1, distance: distance) { success in
                if success {
                    print("모든 과정 완료! DB를 확인해서 올바르게 데이터 저장 됐는지 확인!")
                }
            }
            
        }
        
        //쿼리 실행
        healthStore.execute(query)
    }
                
//            guard let result = result, let sum = result.sumQuantity() else {
//                print("데이터 가져오기에 실패 했어요. 괜찮아요. 다음 스텝으로 넘어갈게요!")
//                return
//            }
            
//            // 미터(m) 단위로 변환해서 출력
//            let distance = sum?.doubleValue(for: HKUnit.meter())
//            print("지난 3개월 동안 \(distance) 미터 만큼 뛰었어요 대단하시네요!")
        
        
    
}
