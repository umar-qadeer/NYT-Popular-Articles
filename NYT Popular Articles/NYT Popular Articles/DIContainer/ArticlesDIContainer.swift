
import Foundation

final class ArticlesDIContainer {
    
    struct Dependencies {
        let networkService: NetworkServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializer
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    private func makeArticlesRepository() -> ArticlesRepositoryProtocol {
        return ArticlesRepository(networkService: dependencies.networkService)
    }
    
    // MARK: - ViewModel
    
    private func makeArticlesViewModel() -> ArticlesViewModel {
        return ArticlesViewModel(articlesRepository: makeArticlesRepository())
    }
    
    // MARK: - ViewController
    
    func makeArticlesViewController(_ coordinator: AppCoordinator) -> ArticlesViewController {
        let viewModel = makeArticlesViewModel()
        let viewController = ArticlesViewController(coordinator, viewModel: viewModel)
        return viewController
    }
}
