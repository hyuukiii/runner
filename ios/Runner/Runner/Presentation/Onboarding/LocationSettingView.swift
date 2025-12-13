//
//  LocationSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/12/25.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct LocationSettingView: View {
    @ObservedObject var viewModel: LoginViewModel // 네비게이션용
    
    // 초기 위치 (서울 시청) - 나중엔 현재 위치로 자동 이동 기능 추가 기능
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var address: String = "위치를 찾는 중. . ."
    @State private var isLoadingAddress: Bool = false
    
    var body: some View {
        ZStack {
            // 지도 (IOS 14+ 호환 방식)
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                .ignoresSafeArea()
                // 지도가 멈추면(움직임이 끝나면) 주소를 가져옴
                .onChange(of: region.center.latitude) {_ in updateAddress()}
            
            // 중앙 고정 핀 (지도가 움직여도 핀은 가만히 있음)
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
                .background(Circle().fill(.white))
                .shadow(radius: 5)
                .offset(y: -20) // 핀의 뾰족한 끝이 중앙에 오도록 살짝 올림
            
            // 하단 주소 표시 및 버튼
            VStack {
                Spacer()
                
                VStack(spacing: 15) {
                    Text("이 위치가 맞나요?")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // 현재 주소 표시
                    Text(address)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        
                    Button(action: {
                        // TODO: 여기서 백엔드로 address 문자열을 보내서 저장 해야 함
                        print("선택된 주소: \(address)")
                        
                        // 로그인 완료 -> ContentView가 감지하고 MatchingView로 전환 됨
                        UserManager.shared.currentUserId = 1
                        
                        // 저장 후 메인으로 이동 TODO: (지금은 임시로 바로 넘김)
                        viewModel.navigationPath = [] // 경로 초기화
                        UserManager.shared.currentUserId = 1
                    }) {
                        Text("이 위치로 설정")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                } // sub VStack
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            } // main VStack
        }
    }
    
    // 좌표 -> 주소 변환 (Reverse Geocoding)
    private func updateAddress() {
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        let geocorder = CLGeocoder()
        
        geocorder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                // 시 + 구 + 동 조합으로
                let city = placemark.administrativeArea ?? "" // OO시
                let district = placemark.locality ?? ""       // OO구
                let dong = placemark.subLocality ?? ""        // OO동
                
                self.address = "\(city) \(district) \(dong)".trimmingCharacters(in: .whitespaces)
            } else {
                self.address = "주소를 찾을 수 없어요"
            }
        }
    }
}
