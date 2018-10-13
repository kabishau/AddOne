import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainViewController: MainViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window!.rootViewController = mainViewController
        window!.makeKeyAndVisible()

        return true
    }
}

