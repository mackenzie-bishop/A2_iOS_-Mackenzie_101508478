import UIKit
import CoreData

class ProductListViewController: UITableViewController {

    private var products: [Product] = []

    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product List"
        fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
        tableView.reloadData()
    }

    private func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]

        do {
            products = try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let product = products[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = product.name ?? "No Name"
        cell.detailTextLabel?.text = product.productDescription ?? "No Description"
        cell.detailTextLabel?.numberOfLines = 2
        return cell
    }
}
