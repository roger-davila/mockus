//
//  Endpoints.swift
//  Near
//
//  Created by Roger Davila on 1/4/23.
//

import Foundation

struct Endpoints {
    static let productCategories = URL(string: "https://dummyjson.com/products/categories")!
    static let allProducts = URL(string: "https://dummyjson.com/products")!
    static let productsByCategoryBase = "https://dummyjson.com/products/category"
    
    static func productsByCategory(category: String) -> URL {
        return URL(string: "\(self.productsByCategoryBase)/\(category)")!
    }
    
    static func productById(id: String) -> URL {
        let base = self.allProducts.absoluteString
        return URL(string: "\(base)/\(id)")!
    }
}
