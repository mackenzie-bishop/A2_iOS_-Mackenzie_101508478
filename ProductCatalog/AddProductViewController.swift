import UIKit
import CoreData

// Screen for adding a new product to the database
class AddProductViewController: UIViewController {

    // Input fields for product details
    private let idField = UITextField()
    private let nameField = UITextField()
    private let descField = UITextField()
    private let priceField = UITextField()
    private let providerField = UITextField()
    
    // Button used to save a new product
    private let saveButton = UIButton(type: .system)

    // Access Core Data context
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Product"
        view.backgroundColor = .systemBackground
        
        // MARK: - UI Setup
        setupUI()
    }

    private func setupUI() {
        [idField, nameField, descField, priceField, providerField].forEach {
            $0.borderStyle = .roundedRect
        }

        idField.placeholder = "Product ID"
        idField.keyboardType = .numberPad
        nameField.placeholder = "Product Name"
        descField.placeholder = "Product Description"
        priceField.placeholder = "Product Price"
        priceField.keyboardType = .decimalPad
        providerField.placeholder = "Product Provider"

        saveButton.setTitle("Save Product", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            idField, nameField, descField, priceField, providerField, saveButton
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

    // Validate all input fields before saving
    @objc private func saveTapped() {
        guard
            let idText = idField.text, let id = Int32(idText),
            let name = nameField.text, !name.isEmpty,
            let desc = descField.text, !desc.isEmpty,
            let priceText = priceField.text, let price = Double(priceText),
            let provider = providerField.text, !provider.isEmpty
        else {
            showAlert(title: "Error", message: "Please fill in all fields with valid values.")
            return
        }

        // Check for duplicate Product ID
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "productID == %d", id)

        do {
            let existing = try context.fetch(request)
            if !existing.isEmpty {
                showAlert(title: "Duplicate ID", message: "A product with that ID already exists.")
                return
            }
        }
        catch {
            showAlert(title: "Error", message: "Could not validate Product ID.")
            return
        }

        // Create and populate new product object
        let product = Product(context: context)
        product.productID = id
        product.name = name
        product.productDescription = desc
        product.price = price
        product.provider = provider

        do {
            try context.save()
            clearFields()
            showAlert(title: "Success", message: "Product added successfully.")
        } catch {
            showAlert(title: "Error", message: "Failed to save product.")
        }
    }

    // Clears all form fields after a successful save
    private func clearFields() {
        idField.text = ""
        nameField.text = ""
        descField.text = ""
        priceField.text = ""
        providerField.text = ""
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
