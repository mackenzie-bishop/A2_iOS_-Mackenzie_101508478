import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let browseVC = UINavigationController(rootViewController: BrowseViewController())
        browseVC.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "arrow.left.arrow.right"), tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let addVC = UINavigationController(rootViewController: AddProductViewController())
        addVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.circle"), tag: 2)

        let listVC = UINavigationController(rootViewController: ProductListViewController())
        listVC.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 3)

        viewControllers = [browseVC, searchVC, addVC, listVC]
    }
}
