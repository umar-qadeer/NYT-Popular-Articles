
import Foundation

protocol ArticlesRepositoryProtocol: AnyObject {
    func fetchArticles() async throws -> [Article]?
}

final class ArticlesRepository: ArticlesRepositoryProtocol {
    
    // MARK: - Variables
    
    private let networkService: NetworkServiceProtocol

    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - ArticlesRepositoryProtocol

    func fetchArticles() async throws -> [Article]? {
        return try await networkService.request(ArticlesRequest())
    }
}
