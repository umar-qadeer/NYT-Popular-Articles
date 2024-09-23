
import Foundation

struct ArticlesResponse: Codable {

    let articles: [Article]?

    enum CodingKeys: String, CodingKey {
        case articles = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        articles = try values.decodeIfPresent([Article].self, forKey: .articles)
    }
}
