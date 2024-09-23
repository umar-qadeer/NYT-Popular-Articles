
import Foundation

final class ArticleDetailDIContainer {
    
    struct Dependencies {
        let networkService: NetworkServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - ViewModel
    
    private func makeArticleDetailViewModel(article: Article) -> ArticleDetailViewModel {
        return ArticleDetailViewModel(article: article)
    }
    
    // MARK: - ViewController
    
    func makeArticleDetailViewController(article: Article) -> ArticleDetailViewController {
        let viewModel = makeArticleDetailViewModel(article: article)
        let viewController = ArticleDetailViewController(viewModel: viewModel)
        return viewController
    }
}
