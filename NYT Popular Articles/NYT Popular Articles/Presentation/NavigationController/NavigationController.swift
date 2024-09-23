
import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = .black

        // Set custom back button image
        let backButtonImage = UIImage(systemName: "arrow.left")
        navigationBar.backIndicatorImage = backButtonImage
        navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationBar.topItem?.backButtonTitle = ""
    }
}
