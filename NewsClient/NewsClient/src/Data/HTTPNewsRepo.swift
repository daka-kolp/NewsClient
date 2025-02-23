//
//  NewsRepo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//

class HTTPNewsRepo: NewsRepo {
    private let networkService: NetworkServiceProtocol
    
    private let baseUrl = "https://newsapi.org/v2"
    private let apiKey = "48ce1f318d0a4ba98993915123afe27d"
    
    init() {
        self.networkService = NetworkService()
    }
    
    func fetchArticles(query: String) async -> Result<[Article], Error> {
        let paramString = "q=\(query)&apiKey=\(apiKey)"
        let urlString = baseUrl + "/everything" + "?\(paramString)"
        return await fetchArticles(urlString: urlString)
    }
    
    private func fetchArticles(urlString: String) async -> Result<[Article], Error> {
        do {
            let result: ArticlesDTO = try await networkService.request(
                endpoint: urlString,
                method: .GET,
                headers: nil,
                body: nil
            )
            let articles = result.articles.map { return $0.toDomainModel() }
            return .success(articles)
        } catch {
            return .failure(error)
        }
    }
}
