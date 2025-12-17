//
//  NicknameSettingView.swift
//  Runner
//
//  Created by 윤현기 on 12/16/25.
// TODO: 다음 버튼에 1 / 3 기능 넣기 , 닉네임 입력칸 허전해서 UI/UX 적으로 개선하기 , 유효성 검사 로직은 실행 될 때만 보여주기

import SwiftUI

struct NicknameSettingView: View {
    // 이전 화면(LoginFlow)에서 주입받을 뷰모델
    @ObservedObject var viewModel: LoginViewModel
    
    // 뒤로가기 동작을 위해 환경변수 추가 (UI에서는 보이지 않음)
    @Environment(\.dismiss) private var dismiss
    
    // 닉네임 입력 상태 관리
    @State private var nickname: String = ""
    @FocusState private var isFocused: Bool
    
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
                
                Text("러닝 메이트들에게 보여질 이름 이에요")
                    .font(.body)
                    .foregroundColor(.gray)
                
            } // 안내 문구 VStack
            .padding(.top, 40)
            
            // 2. 닉네임 입력창 (박스 스타일)
            VStack(alignment: .leading,spacing: 8) {
                
                // HStack 전체에 테두리를 씌우자
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
                            } else {
                                nickname = filtered
                            }
                        }
                    
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
                    } else if !nickname.isEmpty {
                        // 입력 끝나고 키보드 내려갔을 때 성공 표시
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
                // 에니메이션 부드럽게 적용
                .animation(.easeInOut(duration: 0.2), value : isValid)
                .animation(.easeInOut(duration: 0.2), value : isFocused)
            
                // 하단 헬퍼 텍스트 ( 에러 메시지 or 글자수 카운트 )
                HStack {
                    if !nickname.isEmpty && !isValid {
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
