//
//  LocationManager.swift
//  Runner
//
//  Created by 윤현기 on 12/14/25.
//

import CoreLocation
import Combine

// 위치(좌표)를 뽑아내는 클래스
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    // 내 위치를 뱉어주는 변수 (값이 없으면 nil)
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization() // 권한 요청
        manager.startUpdatingLocation() // 위치 추적 시작
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 위치를 잡으면 업데이트 (UI 업데이트를 위해 메인 스레드 보장)
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
        
        // 한 번 잡으면 배터리 절약을 위해 중지
        manager.stopUpdatingLocation()
    }
    
    // TODO: 위치 권한 거부 됐을 때 로직 추가하기
}
