import Foundation
import CoreData

class DataSeeder {

    // Ensures sample data is only inserted once
    
    static func seedIfNeeded(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Product> = Product.fetchRequest()

        do {
            let count = try context.count(for: request)
            if count > 0 { return }

            let products: [(Int32, String, String, Double, String)] = [
                (1, "iPhone 14", "Apple smartphone with strong performance and camera.", 999.99, "Apple"),
                (2, "Galaxy S23", "Samsung flagship smartphone with AMOLED display.", 899.99, "Samsung"),
                (3, "iPad Air", "Lightweight Apple tablet for study and work.", 749.99, "Apple"),
                (4, "MacBook Air", "Thin laptop with excellent battery life.", 1299.99, "Apple"),
                (5, "Surface Pro", "Microsoft 2-in-1 tablet and laptop device.", 1199.99, "Microsoft"),
                (6, "AirPods Pro", "Wireless earbuds with noise cancellation.", 329.99, "Apple"),
                (7, "Sony WH-1000XM5", "Premium over-ear noise cancelling headphones.", 499.99, "Sony"),
                (8, "Kindle Paperwhite", "E-reader with glare-free display.", 189.99, "Amazon"),
                (9, "Apple Watch", "Smartwatch for fitness and notifications.", 549.99, "Apple"),
                (10, "Dell XPS 13", "Compact premium Windows ultrabook.", 1399.99, "Dell")
            ]

            for item in products {
                let product = Product(context: context)
                product.productID = item.0
                product.name = item.1
                product.productDescription = item.2
                product.price = item.3
                product.provider = item.4
            }

            try context.save()
        } catch {
            print("Seeding failed: \(error)")
        }
    }
}
