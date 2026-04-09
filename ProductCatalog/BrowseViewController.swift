import UIKit
import CoreData

// Displays products one at a time and allows navigation between them
class BrowseViewController: UIViewController {

    // Array holding all products
    private var products: [Product] = []
    private var currentIndex: Int = 0

    // UI elements for displaying product details
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let priceLabel = UILabel()
    private let providerLabel = UILabel()
    
    // Navigation buttons
    private let previousButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)

    // Access Core Data context from AppDelegate
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        // MARK: - UI Setup
        setupUI()
        // MARK: - Data Handling
        fetchProducts()
        showCurrentProduct()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data in case products were added/changed
        fetchProducts()
        if currentIndex >= products.count {
            currentIndex = max(0, products.count - 1)
        }
        showCurrentProduct()
    }

    private func setupUI() {
        idLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        descLabel.numberOfLines = 0
        priceLabel.font = .systemFont(ofSize: 18, weight: .medium)
        providerLabel.font = .systemFont(ofSize: 18, weight: .medium)

        previousButton.setTitle("Previous", for: .normal)
        nextButton.setTitle("Next", for: .normal)

        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [previousButton, nextButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 18

        let stack = UIStackView(arrangedSubviews: [
            idLabel, nameLabel, descLabel, priceLabel, providerLabel, buttonStack
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]

        do {
            products = try context.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
        }
    }

    // Updates UI with the currently selected product
    private func showCurrentProduct() {
        guard !products.isEmpty else {
            idLabel.text = "No products found"
            nameLabel.text = ""
            descLabel.text = ""
            priceLabel.text = ""
            providerLabel.text = ""
            previousButton.isEnabled = false
            nextButton.isEnabled = false
            return
        }

        let product = products[currentIndex]
        idLabel.text = "Product ID: \(product.productID)"
        nameLabel.text = "Name: \(product.name ?? "")"
        descLabel.text = "Description: \(product.productDescription ?? "")"
        priceLabel.text = String(format: "Price: $%.2f", product.price)
        providerLabel.text = "Provider: \(product.provider ?? "")"

        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < products.count - 1
    }

    @objc private func previousTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            showCurrentProduct()
        }
    }

    @objc private func nextTapped() {
        if currentIndex < products.count - 1 {
            currentIndex += 1
            showCurrentProduct()
        }
    }
}
