//
//  NetworkService.swift
//  incredible_trata
//
//  Created by Aristova Alina on 15.11.2021.
//  
//

import Foundation

protocol NetworkServiceProtocol {
    func get<T: Codable>(type: T.Type, from url: URL, parameters: [String: String]?, completion: @escaping (Result<T?, Error>) -> Void)
}

final class NetworkService {
    static let shared = NetworkService()
    init() {}
    private func parseJson<T: Decodable>(data: Data, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let result = try JSONDecoder().decode(type.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}

extension NetworkService: NetworkServiceProtocol {
    func get<T: Codable>(type: T.Type,
                         from url: URL,
                         parameters: [String: String]? = nil,
                         completion: @escaping (Result<T?, Error>) -> Void) {
        let urlSubstring = getParamsValue(parameters: parameters)
        guard let url = URL(string: "\(url)\(urlSubstring)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(CustomError(title: "EmptyData",
                                                    description: "Data is empty.", code: CodeError.emptyData)))
                    return
                }
                self?.parseJson(data: data, type: T.self) { result in
                    switch result {
                    case .success(let resultParseJson):
                        completion(.success(resultParseJson))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        dataTask.resume()
    }

    func getParamsValue(parameters: [String: String]? = nil) -> String {
        var paramsValue = ""
        if parameters != nil {
            parameters!.forEach { item in
                if paramsValue.isEmpty {
                    paramsValue = "?\(item.key)=\(item.value)"
                } else {
                    paramsValue = "\(paramsValue)&\(item.key)=\(item.value)"
                }
            }
            return paramsValue
        }
        return ""
    }
}
