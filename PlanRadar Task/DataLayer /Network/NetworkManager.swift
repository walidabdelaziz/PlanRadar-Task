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

        var finalParams = params ?? [:]
        finalParams["appid"] = AppSecrets.openWeatherApiKey
        let safeParams = finalParams

        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.prettyPrinted

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: safeParams,
                encoding: encoding,
                headers: HTTPHeaders(headers)
            ).responseDecodable(of: type) { response in
                print("url \(url)")
                print("params \(safeParams)")
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
