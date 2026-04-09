import UIKit
import CoreData

// Allows users to search for products by name or description
class SearchViewController: UIViewController, UISearchBarDelegate {

    // UI elements for search and displaying results
    private let searchBar = UISearchBar()
    private let resultLabel = UILabel()
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let priceLabel = UILabel()
    private let providerLabel = UILabel()

    // Access Core Data context
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        searchBar.placeholder = "Search products..."
        searchBar.delegate = self

        resultLabel.text = "Type to search for a product"
        resultLabel.font = .systemFont(ofSize: 18, weight: .medium)

        descLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [
            searchBar, resultLabel, idLabel, nameLabel, descLabel, priceLabel, providerLabel
        ])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // Called when user taps search on keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSearch(text: searchBar.text ?? "")
    }

    private func performSearch(text: String) {
        // Prevent empty or whitespace-only searches
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            resultLabel.text = "Enter search text"
            clearLabels()
            return
        }

        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "name CONTAINS[cd] %@", text),
            NSPredicate(format: "productDescription CONTAINS[cd] %@", text)
        ])
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            if let product = results.first {
                resultLabel.text = "Product found"
                idLabel.text = "Product ID: \(product.productID)"
                nameLabel.text = "Name: \(product.name ?? "")"
                descLabel.text = "Description: \(product.productDescription ?? "")"
                priceLabel.text = String(format: "Price: $%.2f", product.price)
                providerLabel.text = "Provider: \(product.provider ?? "")"
            } else {
                resultLabel.text = "No matching product found"
                clearLabels()
            }
        } catch {
            resultLabel.text = "Search failed"
            clearLabels()
        }
    }

    private func clearLabels() {
        idLabel.text = ""
        nameLabel.text = ""
        descLabel.text = ""
        priceLabel.text = ""
        providerLabel.text = ""
    }
}
