
import Foundation

final class AppDIContainer {
    
    lazy var networkService: NetworkServiceProtocol = {
        return NetworkService()
    }()
    
    func makeArticlesDIContainer() -> ArticlesDIContainer {
        let dependencies = ArticlesDIContainer.Dependencies(networkService: networkService)
        return ArticlesDIContainer(dependencies: dependencies)
    }
    
    func makeArticleDetailDIContainer() -> ArticleDetailDIContainer {
        let dependencies = ArticleDetailDIContainer.Dependencies(networkService: networkService)
        return ArticleDetailDIContainer(dependencies: dependencies)
    }
}
