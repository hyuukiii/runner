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
    
    // 서버 주소 (시뮬레이터에서 맥북 localhost는 localhost로 통함)
    // http://192.168.0.167:8080 http://localhost:8080
    let baseURL = "http://localhost:8080"
    
    
    /**
      * 러닝 기록 업로드 함수
      * completion : 완료되면 실행할 것, @escaping : 탈출한다
      * (Bool) : 성공/실패(True/false) 반환
      * Void   : 결과 반환 x, 할 일만 하고 끝냄
    **/
    func uploadRunningRecord(userId : Int, distance: Double, completion: @escaping (Bool) -> Void) {
        
        // 1. URL 설정
        guard let url = URL(string: "\(baseURL)/running/record") else{return}
        
        // 2. 요청(Request) 만들기
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
            
            //200코드 발생 시 로직
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
        
    } // uploadRunningRecord
    
    /**
        1. 이메일 인증번호 요청 (POST / auth/ send-code)
     */
    func sendVerificationCode(email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/send-code") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("JSON 변환 실패")
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("전송 실패: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("인증번호 발송 성공")
                completion(true)
            } else {
                print("발송 실패(status code를 확인)")
                completion(false)
            }
        }.resume()
    } // sendVerificationCode
    
    /**
        인증번호 검증 & 로그인
     */
    func verifyCode(email: String, code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/verify") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email, "code": code]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {return}
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("인증 완료 로그인 성공")
                // 나중에는 여기서 서버가 준 JWT토큰을 저장 해야 함!
                completion(true)
            } else {
                print("로그인 실패(인증번호 불일치)")
                completion(false)
            }
        }.resume()
    } // verifyCode
    
            
} // class
