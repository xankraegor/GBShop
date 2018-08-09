import Foundation

struct AddProductResult: Codable {
    
    let result: Int
}

struct RemoveProductResult: Codable {
    
    let result: Int
}

struct BasketItem: Codable {
    let id: Int
    let productName: String
    let price: Double
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id_product"
        case productName = "product_name"
        case price = "price"
        case quantity = "quantity"
    }
}

struct GetBasketResult: Codable {
    
    let amount: Int
    let count: Int
    let contents: [BasketItem]
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case count = "countGoods"
        case contents = "contents"
    }
    
}


typealias CatalogDataResult = Array<Product>
struct Product: Codable {
    let id: Int
    let productName: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id_product"
        case productName = "product_name"
        case price = "price"
    }
}




