//
//  APIManager.swift
//  Runner
//
//  Created by 윤현기 on 12/2/25.
//

import Foundation

class APIManager {
    
    //싱글톤 패턴 (전국에 지점이 하나뿐인 본점)
    static let shared = APIManager()
    
    //서버 주소 (시뮬레이터에서 맥북 localhost는 localhost로 통함)
    let baseURL = "http://localhost:8080"
    
    // 러닝 기록 업로드 함수
    // completion : 완료되면 실행할 것, @escaping : 탈출한다
    // (Bool) : 성공/실패(True/false) 반환
    // Void   : 결과 반환 x, 할 일만 하고 끝냄
    func uploadRunningRecord(userId : Int, distance: Double, completion: @escaping (Bool) -> Void) {
        
        // 1. URL 설정
        guard let url = URL(string: "\(baseURL)/running/record") else{return}
        
        // 2. 요청(Request) 만들기 ( 해당 코드 3줄 물어보기 )
        // var를 쓴 이유는 구조체이기 떄문에 내용 수정을 위해 변수로 선언
        // request.httpMethod = "POST" ==> 아무것도 안적으면 기본값(GET)임
        // "application/json"          ==> 이 안에는 일반 텍스트나 이미지X, JSON 형식의 데이터가 있음을 명시
        // forHTTPHeaderField: "Content-Type" ==> "내용물의 종류" 적는 칸
        // 내가 만든 스프링 부트 서버 컨트롤러는 " @RequestBody RunningRecordRequest request " 이런 형식임
        // 스프링은 이 Header를 보고 아 JSON이네 내가 파싱해서 자바 객체로 바꿔야겠어! 라고 판단함
        // 이걸 적지 않으면 서버는 데이터를 텍스트 덩어리로 인식해서 415에러가 터짐
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3. 보낼 데이터(Body) 포장하기 (JSON)
        // DTO랑 똑같이 맞춰줘야 함
        let body: [String: Any] = [
            "userId": userId,
            "distance": distance / 1000.0, // 미터를 Km로 변환해서 보냄 (서버는 km 기준이라 가정)
            "duration": 3600, // (임시데이터) 1시간 뛰었다고 가정
            "calories": 300   // (임시데이터) 300칼로리
        ]
        
        // JSONSerialization.data(withJSONObject: body) === Swift 딕셔너리를 JSON타입으로 변환 (직렬화)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Swift딕셔너리 === JSON로 변환 실패 : \(error)")
            return
        }
        
        // 4. 전송 시작 (URLSession)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("서버 통신 에러:\(error.localizedDescription)")
                completion(false)
                return
            }
            
            // as?가 뭔지 물어보기
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("서버 업로드 성공! (200 OK)")
                // 응답 데이터 확인 (String)
                if let data = data, let responseString = String(data: data,encoding: .utf8) {
                    print("서버 응답: \(responseString)")
                }
                completion(true)
            } else {
                print("서버 응답 실패(Status Code가 200이 아님)")
                completion(false)
            }
        }.resume()
        
        
    }
}
