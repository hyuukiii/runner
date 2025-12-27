//
//  LocationSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/12/25.
//

import SwiftUI
import MapKit

struct LocationSettingView: View {
    @ObservedObject var viewModel: LoginViewModel
    @StateObject private var locationVM = LocationViewModel()
    
    // MARK: Body 디자인 시작
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // MARK: 지도 (배경)
            Map(coordinateRegion: $locationVM.region, interactionModes: .all, showsUserLocation: true)
                .ignoresSafeArea()
                .onChange(of: locationVM.region.center.latitude) { _ in
                    locationVM.updateAddressFromMap()
                }
            
            // MARK: 하단 정보 시트
            VStack(spacing: 0) { // Spacing을 0으로 하고 Spacer()로 조절
                
                // MARK: 상단 영역 : 안내 멘트 & 핵심 위치 정보
                VStack(spacing: 10) {
                    Text(" 매칭을 위해 사는 지역이 필요해요 ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 20) // 시트 위쪽 여백
                    
                    // MARK: 위치 표시 텍스트
                    HStack(spacing: 0) {
                        Text("현재 계신 곳은 ")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        // MARK: 로딩 중 애니메이션 or 동네 이름
                        if locationVM.dongName.isEmpty {
                            BlinkingDots()
                        } else {
                            Text("'\(locationVM.dongName)'")
                                .font(.title2) // 가장 크게
                                .fontWeight(.heavy) // 두께도 가장 두껍게
                                .foregroundColor(.blue)
                        }
                        
                        Text(" 이시군요!")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .padding(.top, 5) // 위 멘트랑 살짝 띄우기
                }
                
                // 중앙 공백: 위 내용은 위로, 아래 내용은 아래로 쫙 밀어버림
                Spacer()
                
                // (3) 하단 영역: 버튼 & 변경 안내
                VStack(spacing: 15) {
                    // 완료 버튼
                    Button(action: {
                        if !locationVM.dongName.isEmpty {
                            completeSetting()
                        }
                    }) {
                        Text(" 다음 ")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16) // 버튼 높이감 있게
                            .background(locationVM.dongName.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(14)
                    }
                    .disabled(locationVM.dongName.isEmpty)
                    
                    // MARK: 마이페이지 변경 안내 (맨 아래 배치)
                    Text("마이페이지에서 언제든지 변경할 수 있어요")
                        .font(.caption2)
                        .foregroundColor(Color.gray.opacity(0.7))
                        .padding(.bottom, 10) // 바닥에서 살짝 띄우기
                }
                .padding(.horizontal, 20) // 좌우 여백
                .padding(.bottom, 5)     // 시트 끝부분 여백
            }
            .frame(height: 200) // 시트 높이를 고정하기 안정감 주기
            .background(
                Color.white
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                    .ignoresSafeArea(edges: .bottom) // 흰 배경은 끝까지 내리기
            )
        }
    }
    
    // MARK: 다음 화면으로 넘어가는 함수
    private func completeSetting() {
        print("최종 선택: \(locationVM.dongName)")
        // 선택한 지역은 VM의 dongName에 임시 저장 최종 회원가입 화면단에서 LoginViewModel에 저장 해야 하니
        viewModel.region = locationVM.dongName
        viewModel.navigationPath.append(.nickname)
    }
}

// MARK: 깜빡이는 애니메이션 뷰
struct BlinkingDots: View {
    @State private var isActive = false
    
    var body: some View {
        Text(" . . . ")
            .font(.title2)
            .fontWeight(.heavy)
            .foregroundColor(.gray)
            .opacity(isActive ? 0.3 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                    isActive = true
                }
            }
    }
}

// MARK: 둥근 모서리 확장
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: 코너의 쉐입을 설정하는 구조체
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


#Preview {
    LocationSettingView(viewModel: LoginViewModel())
}
    
