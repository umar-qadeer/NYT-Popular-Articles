
import Foundation

struct ArticlesRequest: DataRequest {

    var days: Int = 7

    var url: String {
        let baseURL: String = NetworkConstants.baseURL
        let path: String = NetworkConstants.EndPoints.articles
        return String(format: baseURL + path, days)
    }

    var method: HTTPMethod {
        .get
    }

    func decode(_ data: Data) throws -> [Article]? {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ArticlesResponse.self, from: data)
        return response.articles
    }
}
