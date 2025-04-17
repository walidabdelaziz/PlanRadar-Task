//
//  NetworkManager.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import Alamofire

protocol NetworkService {
    func request<T: Decodable>(
        method: HTTPMethod,
        url: String,
        headers: [String: String],
        params: Parameters?,
        of type: T.Type
    ) async throws -> T
}

actor NetworkManager: NetworkService {
    func request<T: Decodable>(
        method: HTTPMethod,
        url: String,
        headers: [String: String] = [:],
        params: Parameters?,
        of type: T.Type
    ) async throws -> T {
        var allHeaders: [String: String] = [
            "content-language": "en",
            "platform": "Postman",
            "private-key": "Tg$LXgp7uK!D@aAj^aT3TmWY9a9u#qh5g&xgEETJ"
        ]
        headers.forEach { key, value in
            allHeaders[key] = value
        }
        var encoding: ParameterEncoding = JSONEncoding.prettyPrinted
        if method == .get {
            encoding = URLEncoding.default
        }
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: params,
                encoding: encoding,
                headers: HTTPHeaders(allHeaders)
            ).responseDecodable(of: type) { response in
                print("url \(url)")
                print("params \(params ?? [:])")
                switch response.result {
                case let .success(data):
                    print("response \(data)")
                    continuation.resume(returning: data)
                case let .failure(error):
                    print("error \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
