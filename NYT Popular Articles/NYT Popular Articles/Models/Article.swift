
import Foundation

struct Article: Codable {
    
    let url: String?
    let publishedDate: String?
    let byline: String?
    let title: String?
    let abstract: String?
    let media: [Media]?

    var thumbnailURL: String? {
        media?.first?.mediaMetadata?.first?.url
    }

    var imageURL: String? {
        media?.first?.mediaMetadata?.last?.url
    }

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case publishedDate = "published_date"
        case byline = "byline"
        case title = "title"
        case abstract = "abstract"
        case media = "media"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        publishedDate = try values.decodeIfPresent(String.self, forKey: .publishedDate)
        byline = try values.decodeIfPresent(String.self, forKey: .byline)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
        media = try values.decodeIfPresent([Media].self, forKey: .media)
    }
}
