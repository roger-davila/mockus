//
//  Product.swift
//  Near
//
//  Created by Roger Davila on 1/3/23.
//

import Foundation

class ProductResponse: Codable {
    var products: [Product]
}

class Product: Codable {
    var id: Int
    var title: String
    var description: String
    var price: Double
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var brand: String
    var category: String
    var thumbnail: String
    var images: [String]
}

class ProductCategoryPreview {
    var name: String
    var products: [Product]
    
    init(name: String, products: [Product] = []) {
        self.name = name
        self.products = products
    }
}
