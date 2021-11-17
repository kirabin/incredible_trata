//
//  NetworkServiceManager.swift
//  incredible_trata
//
//  Created by Aristova Alina on 15.11.2021.
//  
//

import Foundation

final class CurrencyNetworkManager {

    static let shared = CurrencyNetworkManager()

    // MARK: - public variable
    var exchangeRates: ExchangeRates? {
        didSet {
            print(exchangeRates?.quotes)
            print(exchangeRates?.success)
        }
    }

    // MARK: - private variable
    private var networkServiсe = NetworkService()
    private var accessKey: String?

    // MARK: - public methods
    func obtainCurrency() {
        let urlString = "http://api.currencylayer.com/live"
        let parameters = getParameters()
        guard let url = URL(string: urlString)
        else { return }
        networkServiсe.get(type: ExchangeRates.self, from: url, parameters: parameters) { [self] answer in
            DispatchQueue.main.async {
                switch answer {
                case .success(let result):
                    exchangeRates = result

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - private methods
    private func getAccessKey() -> String? {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            guard let keys = NSDictionary(contentsOfFile: path) else { return nil }
            accessKey = (keys["AccessKey"] as? String)
            if let accessKey = accessKey {
                return accessKey
            }
        }
        return nil
    }

    func getParameters() -> [String: String]? {
        let key = getAccessKey()
        var parameters = ["currencies": "USD,GBP,AUD"]

        if key != nil && key != "" {
            parameters["access_key"] = key!
        } else { return nil }
        return parameters
    }
}

struct ExchangeRates: Codable {
    let success: Bool
    let terms: String
    let source: String
    let quotes: [String: Double]
}
