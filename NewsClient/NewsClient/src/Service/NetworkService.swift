//
//  NetworkService.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//


import Foundation

protocol NetworkServiceProtocol {
    
    func request<T: Decodable>(
        endpoint: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?
    ) async throws -> T

    func requestArray<T: Decodable>(
        endpoint: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?
    ) async throws -> [T]
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

final class NetworkService: NetworkServiceProtocol {
    
    func request<T: Decodable>(
        endpoint: URL,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> T {
        let request = try buildRequest(url: endpoint, method: method, headers: headers, body: body)
        return try await performRequest(request)
    }

    func requestArray<T: Decodable>(
        endpoint: URL,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> [T] {
        let request = try buildRequest(url: endpoint, method: method, headers: headers, body: body)
        return try await performRequest(request)
    }

    private func buildRequest(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpBody = body
        return request
    }

    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "HTTPError",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey: "Bad response: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                ]
            )
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}
