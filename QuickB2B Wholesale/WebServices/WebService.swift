//
//  WebService.swift
//  HotCoffee
//
//  Created by Gopabandhu on 19/10/20.
//  Copyright © 2020 Gopabandhu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum NetworkError: String, Error {
    case decodingError = "Server not found. Please try again later."
    case domainError = "Server Not Found!"
    case urlError = ""
    case networkError = "You have a poor network connection. Please reconnect & try again later."
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIKey: String {
    case apiKey = "sBES0NksSthaizzle2021ZmMbg8F6Bo87A"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethods: HttpMethod = .post//.get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

//API Key For Development - "ThaizzleByBT"
class WebService {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T,NetworkError>) -> Void) {
        if Connectivity.isConnectedToInternet {
            var request = URLRequest(url: resource.url)
            request.httpMethod = resource.httpMethods.rawValue
            request.httpBody = resource.body
            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            URLSession.shared.dataTask(with: request) { data, response, error in
                print("Api Name:: ",resource.url)
                print("Response:: ",JSON(data))
                if let error = error {
                    completion(.failure(.networkError))
                    return
                }
           
                guard let data = data, error == nil else {
                    completion(.failure(.domainError))
                    return
                }
                
                let result = try? JSONDecoder().decode(T.self, from: data)
                if let result = result {
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } else {
                    completion(.failure(.decodingError))
                }
            }.resume()
        } else {
            completion(.failure(.networkError))
        }
    }
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()
    static var isConnectedToInternet:Bool {
        return self.sharedInstance?.isReachable ?? false
    }
}
