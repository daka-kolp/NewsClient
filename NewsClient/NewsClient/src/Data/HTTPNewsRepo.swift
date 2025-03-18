//
//  NewsRepo.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 23.02.2025.
//


class HTTPNewsRepo: NewsRepo {
    static let instance = HTTPNewsRepo()
    
    private let networkService: NetworkServiceProtocol
    private let localStorage: LocalStorageService
    
    private let baseUrl = "https://newsapi.org/v2"
    private let apiKey = "48ce1f318d0a4ba98993915123afe27d"
    private let pageSize = 20
    
    private init() {
        self.networkService = NetworkService()
        self.localStorage = LocalStorageService.instance
    }
    
    func fetchArticlesByQuery(query: String, page: Int) async -> Result<[Article], Error> {
        let languageCode = localStorage.articleLanguage

        let paramString = "language=\(languageCode)&pageSize=\(pageSize)&page=\(page)&q=\(query)&apiKey=\(apiKey)"
        let urlString = baseUrl + "/everything" + "?\(paramString)"
        return await fetchArticles(urlString: urlString)
    }
    
    func fetchTopArticles(page: Int) async -> Result<[Article], Error> {
        let paramString = "country=us&pageSize=\(pageSize)&page=\(page)&apiKey=\(apiKey)"
        let urlString = baseUrl + "/top-headlines" + "?\(paramString)"
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
            print("------fetchArticles SUCCESS------")
            print(result.articles.count)
            print(result.totalResults)
            print("-----------------")
            let articles = result.articles.map { return $0.toDomainModel() }
            return .success(articles)
        } catch {
            print("------fetchArticles ERROR------")
            print(urlString)
            print(error.localizedDescription)
            print("-----------------")
            return .failure(error)
        }
    }
}
