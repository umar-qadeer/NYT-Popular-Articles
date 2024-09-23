
import Foundation

struct NetworkConstants {
    // API base url
    static let baseURL = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/"
    static let apiKey = "VvG4W3LLK7ttAeNFhA92AiMibjpDtpFT"

    struct EndPoints {
        static let articles = "all-sections/%u.json"
    }
}
