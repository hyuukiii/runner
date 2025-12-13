//
//  LocationSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/12/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationSettingView: View {
    // 네비게이션용
    @ObservedObject var viewModel: LoginViewModel
    
    // 뷰모델 호출
    @StateObject private var locationVM = LocationViewModel()
    
    // 상단 안내 메시지 표시 여부
    @State private var showToast: Bool = false
    
    var body: some View {
        ZStack {
            // 1. 지도( 전체 화면 )
            Map(coordinateRegion: $locationVM.region, interactionModes: .all, showsUserLocation: true)
                .ignoresSafeArea()
            // 지도가 멈추면(값이 바뀌면) -> 주소 가져오기 (Reverse Geocoding)
                .onChange(of: locationVM.region.center.latitude) { _ in
                    // 수동으로 주소를 치고있는게 아닐때만 지도를 따라감
                    if !locationVM.isMapMoving {
                        locationVM.updateAddressFromMap()
                    }
                }
            
            // 2. 중앙 핀 (항상 가운데 고정)
            Image(systemName: "mappin")
                .font(.system(size: 40))
                .foregroundColor(.red)
                .shadow(radius: 5)
                .offset(y: -20) // 핀 끝을 중앙에 맞춤
        
        // 3. UI (상단 토스트 + 하단 입력창)
        VStack {
            // [상단] 튜토리얼 토스트 메시지
            if showToast {
                Text("매칭을 위해 살고 계신 지역이 필요해요")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(25)
                    .padding(.top, 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
            } // showToast
            
            Spacer()
            
            // [하단] 주소 입력 및 완료 카드
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    // 주소 입력창 (수정 가능)
                    TextField("지도를 움직이거나 주소를 입력하세요", text: $locationVM.addressText)
                    // 엔터 누르면 -> 지도를 해당 주소로 이동
                        .onSubmit { locationVM.updateMapFromAddress() }
                        .submitLabel(.search)
                }
                .padding()
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(10)
                
                // 완료 버튼
                Button(action: {
                    completeSetting()
                }) {
                    Text("이 위치로 설정")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
            .padding(.bottom, 20) // 홈bar를 고려하여 하단 여백 주기
        } // VStack
    } // ZStack
    .onAppear {
        // 화면 켜지면 토스트 띄우기
        withAnimation{ showToast = true}
            
        // 3초 뒤에 토스트 없애기
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        withAnimation{ showToast = false}
       }
     } // onAppear
  }

  private func completeSetting() {
      print("최종주소 \(locationVM.addressText)")
      // TODO: 서버 전송
      UserManager.shared.currentUserId = 1
      viewModel.navigationPath = []
  }
}
    
    
