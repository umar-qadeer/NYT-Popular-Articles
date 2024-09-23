
import Foundation
import Combine

final class ArticleDetailViewModel {

    // MARK: - Properties

    @Published var article: Article

    // MARK: - Init

    init(article: Article) {
        self.article = article
    }
}
