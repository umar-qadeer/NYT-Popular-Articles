
import Foundation

struct Media: Codable {

    let mediaMetadata: [MediaMetadata]?

    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaMetadata = try values.decodeIfPresent([MediaMetadata].self, forKey: .mediaMetadata)
    }
}
