//
//  APIService.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/20/25.
//

import Foundation

class APIService {
    internal func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }

            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodedData)
                //실패 상황 가정 alert 확인하기/ 확인 완료
//                completion(nil)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }

}
