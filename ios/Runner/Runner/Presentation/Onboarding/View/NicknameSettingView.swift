//
//  NicknameSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/16/25.
// TODO: 다음 버튼에 1 / 3 기능 넣기 , 닉네임 입력칸 허전해서 UI/UX 적으로 개선하기 , 유효성 검사 로직은 실행 될 때만 보여주기

import SwiftUI
import PhotosUI

struct NicknameSettingView: View {
    // 이전 화면(LoginFlow)에서 주입받을 뷰모델
    @ObservedObject var viewModel: LoginViewModel
    
    // 뒤로가기 동작을 위해 환경변수 추가 (UI에서는 보이지 않음)
    @Environment(\.dismiss) private var dismiss
    
    // 닉네임 입력 상태 관리
    @State private var nickname: String = ""
    @FocusState private var isFocused: Bool
    
    // 갤러리 연동 변수
    @State private var selectedItem: PhotosPickerItem? = nil
    
    // 진동 타이밍 잡기용 변수(이전 상태를 기억하기 위함)
    @State private var isLastValid: Bool = false
    // 화면 흔들림 변수
    @State private var shakeTrigger: CGFloat = 0
    
    // 유효성 검사 ( 2~10자, 공백 없음 )
    private var isValid: Bool {
        return nickname.count >= 2 && nickname.count <= 10 && !nickname.contains(" ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // 1. 상단 안내 문구
            VStack(alignment: .leading, spacing: 10) {
                Text("어떤 닉네임으로\n불러드릴까요?")
                    .font(.system(size: 26, weight: .bold))
                    .lineSpacing(4) // 줄 간격 살짝 띄우기
                
                Text("러너들에게 보여질 이름 이에요")
                    .font(.body)
                    .foregroundColor(.gray)
                
            } // 안내 문구 VStack
            .padding(.top, 40)
            
            // 프로필 사진 선택 영역 ( 가운데 정렬 )
            HStack {
                Spacer() // 좌우 Spacer로 가운데 정렬
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        // 1. 프로필 이미지 ( 없으면 기본 아이콘 )
                        if let image = viewModel.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            // 선택된 사진이 없을 때 (기본 회색 원 + 사람 아이콘)
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray.opacity(0.5))
                                )
                        }
                        
                        // 카메라 배지(우측 하단)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white)
                                    .padding(6)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .overlay (
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2) // 흰색 테두리로 분리감 주기
                                    )
                            }
                        }
                    }
                    .frame(width: 100, height: 100) // 전체 터치 영역
                } // PhotosPicker
                
                // 사진 선택 시 데이터 변환 로직
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // 선택한 아이템을 데이터로 로드 -> UIImag로 변환
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                // 뷰모델에 저장 ( 메인 스레드에서 UI 업데이트 )
                            await MainActor.run {
                                viewModel.profileImage = uiImage
                                HapticManager.instance.impact(style: .light) // 엄청 가벼운 진동
                            }
                        }
                    }
                }
                
                Spacer() // 좌우 Spacer로 가운데 정렬
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            // 2. 닉네임 입력창 (박스 스타일)
            VStack(alignment: .leading,spacing: 8) {
                
                // '닉네임 입력' 박스를 프레임으로 씌우자
                HStack {
                    TextField("닉네임 입력", text: $nickname)
                        .font(.title3) // 박스 안의 글자는 조금 줄여서 균형 맞추기
                        .focused($isFocused) // 화면 켜지면 바로 포커스됨
                        .padding(.vertical, 4) // 텍스트 위 아래 살짝 여백
                        .onChange(of: nickname) { newValue in
                            // 공백 제거 및 글자 수 10자 제한
                            let filtered = newValue.replacingOccurrences(of: " ", with: "")
                            if filtered.count > 10 {
                                nickname = String(nickname.prefix(10))
                                // 글자수 꽉 차면 가벼운 진동
                                HapticManager.instance.impact(style: .rigid)
                            } else {
                                nickname = filtered
                            }
                            
                            // 진동 상태가 변하는 순간을 저장하는 변수
                            let currentStatus = (nickname.count >= 2 && nickname.count <= 10)
                            
                            // 상태가 달라졌을 때만 진동 (무한 진동 방지)
                            if currentStatus != isLastValid {
                                if currentStatus {
                                    // 성공(Valid)
                                    HapticManager.instance.notification(type: .success)
                                }
                                // 현재 진동 상태 저장
                                isLastValid = currentStatus
                            }
                        }
                    // 실패(Error) -> 2글자 미만이 되었을 떄
                        .onChange(of: isFocused) { focused in
                            // 입력중 X + 유효 X + 비어있지않음
                            if !focused && !isValid && !nickname.isEmpty {
                                HapticManager.instance.notification(type: .error)
                                withAnimation(.default) {
                                    shakeTrigger += 1
                                }
                            }
                        } // onChange
                    
                /**
                     * 상태에 따라 아이콘 바꾸기
                     - 1순위 : 수정중 + 글자가 있으면 -> 'X' 버튼
                     - 2순위 : 입력완료 + 유효하다면 -> '체크' 아이콘
                */
                    if isFocused && !nickname.isEmpty {
                        // 입력 중일 땐 지우기가 우선
                        Button(action: {
                            nickname = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                    } else if isValid {
                        // 입력 끝나고 유효해야 키보드 내려갔을 때 성공 표시
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                            .transition(.scale.combined(with: .opacity)) // 나타날 때 살짝 튀어오르는 애니메이션
                    }
                }
                .padding(16) // 박스 내부 여백
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        // 테두리 색상 로직 : 가능(초록) -> 포커스(파랑) -> 평소(회색)
                        .stroke(isFocused ? Color.blue : (isValid ? Color.green : Color.gray.opacity(0.3)), lineWidth: 1.5)
                )
                // 뷰에 ShakeEffect 추가
                // animatableData 값이 변할 떄 마다 흔들림.
                .modifier(ShakeEffect(animatableData: shakeTrigger))
                
                // 에니메이션 부드럽게 적용
                .animation(.easeInOut(duration: 0.2), value : isValid)
                .animation(.easeInOut(duration: 0.2), value : isFocused)
            
                // 하단 헬퍼 텍스트 ( 에러 메시지 or 글자수 카운트 )
                HStack {
                    if !isFocused && !nickname.isEmpty && !isValid {
                        // 글자가 있는데 조건이 안 맞을 떄만 에러 메시지 표시
                        Text("2글자 이상 가능해요")
                            .font(.caption)
                            .foregroundColor(.red)
                            // 투명도 + 위에서 아래로 살짝 내려오는 효과
                            .transition(.move(edge: .top).combined(with: .opacity))
                    } else if isValid {
                        // 성공했을 때 칭찬 멘트
                        Text("멋진 닉네임이에요!")
                            .font(.caption)
                            .foregroundColor(.green)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    } else {
                        Spacer()
                    }
                    
                    Spacer() // 오른쪽 정렬을 위해
                    
                    // 글자 수 표시 (1/10)
                    Text("\(nickname.count) / 10")
                        .font(.caption)
                        .foregroundColor(isValid ? .gray : .gray.opacity(0.5))
                }
                .padding(.horizontal, 4) // 텍스트 위치 살짝 보정
                
                // 이 컨테이너 안의 내용이 변할 때 부드럽게 처리하기
                .animation(.easeInOut(duration: 0.3), value: isValid)
                .animation(.easeInOut(duration: 0.3), value: isFocused) // 포커스 상태 변화 에니메이션 추가
                .animation(.easeInOut(duration: 0.3), value: nickname.isEmpty)
            }
            .padding(.top, 30)
            .padding(.horizontal, 24)
            
            Spacer()
            
            //3. 다음 버튼 ( 1/3 단계 표시 추가 )
            Button(action: {
                goNext()
            }) {
                HStack(spacing: 15) {
                    Text("다음")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    // 단계 표시 (1/3)
                    Text("1 / 3")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .opacity(0.6) // 살짝 투명하게 해서 '다음' 글자 강조하기
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(isValid ? Color.blue : Color.gray.opacity(0.3)) // 비활성화 시 회색
                .cornerRadius(16)
            }
            .disabled(!isValid) // 유효하지 않으면 클릭 불가
            .padding(.horizontal, 24)
            .padding(.bottom, 10) // 키보드 올라오면 자동으로 위치 조정됨 (키보드 위 여백)
        }
        .onAppear {
            // 화면 진입 시 0.5초 뒤 키보드 올리기 (자연스러운 UX)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
            // 네비게이션 바 커스텀 하기
            .navigationBarBackButtonHidden(true) // 기본 버튼 숨기기
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // 뒤로가기 로직
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.leading, 8)
                    }
                }
            }
        } // 부모 VStack
        
        // 다음 화면으로 이동
        private func goNext() {
            
            // 뷰모델에 닉네임 저장
            viewModel.nickname = nickname
                    
            // 다음 단계(성별/나이)로 네비게이션 이동
            viewModel.navigationPath.append(.genderInfo)
        }
    }


// 프리뷰
#Preview {
    NicknameSettingView(viewModel: LoginViewModel())
}
