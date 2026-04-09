import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Browse screen inside a navigation controller
        let browseVC = UINavigationController(rootViewController: BrowseViewController())
        browseVC.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "arrow.left.arrow.right"), tag: 0)

        // Create Search screen
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        // Create Add Product screen
        let addVC = UINavigationController(rootViewController: AddProductViewController())
        addVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.circle"), tag: 2)

        // Create Product List screen
        let listVC = UINavigationController(rootViewController: ProductListViewController())
        listVC.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 3)

        // Assign all view controllers to the tab bar
        viewControllers = [browseVC, searchVC, addVC, listVC]
    }
}
