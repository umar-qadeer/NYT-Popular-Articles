
import UIKit

final class ImageService {

    private static var imageCache = NSCache<AnyObject, AnyObject>()

    class func download(from url: String?) async -> UIImage? {

        guard let url,
              let url = URL(string: url) else {
            return nil
        }

        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return cachedImage
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: url as AnyObject)
                return image
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
