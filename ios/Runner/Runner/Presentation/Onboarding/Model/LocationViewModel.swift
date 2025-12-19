//
//  LocationViewModel.swift
//  Runner
//
//  Created by 윤현기 on 12/14/25.
//

import SwiftUI
import Combine
import MapKit

// 좌표를 받아서 주소로 바꾸고, 지도 화면을 수정 함
class LocationViewModel: ObservableObject {
    
    // 위치 매니저 호출
    private let locationManager = LocationManager()
    private var cancellabls = Set<AnyCancellable>() // 구독 티켓 저장소
    
    // 지도 중심 좌표 ( 서울 시청 기본값 )
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    // UI 전역변수
    @Published var addressText: String = ""     // 인풋박스에 들어갈 주소
    @Published var dongName: String = ""        // UI 표시용 (예: 00동)
    @Published var isMapMoving: Bool = false    // 지도가 움직이는 중인지 체크

    // 내부 도구들
    private let geocoder = CLGeocoder()
    private var searchTask: Task<Void, Never>? // 디바운스 처리를 위한 테스크
    
    // 생성자
    init() {
        // LocationMangaer가 위치를 찾으면 -> 나의 위치를 업데이트 하라고 연결
        locationManager.$userLocation
            .compactMap { $0 } // nil이 아닐 떄만
            .first() // 계속 따라다니면 지도 못 움직이니 한번만 받음
            .receive(on: DispatchQueue.main) // 화면 그러야 하니 메인 스레드에서
            .sink{ [weak self] coordinate in
                guard let self = self else { return }
                //지도 이동
                withAnimation {
                    self.region.center = coordinate
                }
                //이동한 곳 주소도 바로 찾기
                self.updateAddressFromMap()
            }
            .store(in: &cancellabls)
    }
    
    // MARK: - 비즈니스 로직 ( 지도 <-> 주소 변환)
    
    func updateAddressFromMap() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 800_000_000) // 디바운스
            
            // 3. 취소 되었는지 확인 (지도가 또 움직인다면 여기서 멈춤)
            if Task.isCancelled { return }
                        
            let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            
            // 4. 주소 변환 시작
            do {
                guard let placemark = try await geocoder.reverseGeocodeLocation(location).first else { return }
                
                // 취소 확인 (네트워크 통신 중에 지도가 움직였을 수도 있음)
                if Task.isCancelled { return }
                
                // 주소 조합 로직
                let adminArea = placemark.administrativeArea ?? "" // 서울특별시
                let locality = placemark.locality ?? "" // 서울특별시 (가끔 중복 됨) or 성남시
                let subLocality = placemark.subLocality ?? "" // 강남구 or 분당구
                let thoroughfare = placemark.thoroughfare ?? "" // 역삼동 or 판교로
                
                // 중복 제거 및 깔끔하게 합치기
                var addressParts: [String] = []
                
                // 한국식 주소를 정제하기
                if !adminArea.isEmpty { addressParts.append(adminArea) }
                if !locality.isEmpty && locality != adminArea { addressParts.append(locality) }
                if !subLocality.isEmpty { addressParts.append(subLocality) }
                if subLocality.isEmpty && !thoroughfare.isEmpty { addressParts.append(thoroughfare) }
                
                let newAddress = addressParts.joined(separator: " ")
                
                // 동네 이름만 추출 (UI용) ( 동 -> 없으면 면/리 -> 없으면 도로명 )
                let simpleName = !subLocality.isEmpty ? subLocality : (placemark.thoroughfare ?? locality)
                
                // UI 업데이트
                DispatchQueue.main.async {
                    self.addressText = newAddress
                    self.dongName = simpleName
                    print("📍 주소 업데이트 완료: \(newAddress)")
                }
                
            } catch {
                // 에러 발생 시 (너무 많이 요청했거나 네트워크 문제)
                print("⚠️ 주소 변환 실패: \(error.localizedDescription)")
            }
        }
    } // updateAddressFromMap
    
    func updateMapFromAddress() {
        isMapMoving = true
        geocoder.geocodeAddressString(addressText) { placemarks, error in
            if let location = placemarks?.first?.location {
                withAnimation {
                    self.region.center = location.coordinate
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isMapMoving = false
            }
        }
    } // updateMapFromAddress
    
}

