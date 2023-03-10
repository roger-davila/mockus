//
//  ProductServices.swift
//  Near
//
//  Created by Roger Davila on 1/4/23.
//

import Foundation
import UIKit

class ProductService {

    enum ProductServiceError: Error {
        case emptyResponse
    }
    
    func getProductCategories(url: URL) async throws -> [String] {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let categories = try JSONDecoder().decode([String].self, from: data)
            return categories
        } catch {
            print(error)
            throw ProductServiceError.emptyResponse
        }
    }
    
    func getProductCategoryPreviews(categories: [String]) async throws -> [ProductCategoryPreview] {
        var categoryPreviews: [ProductCategoryPreview] = []
        try await withThrowingTaskGroup(of: (String, [Product]).self) { taskGroup in
            for category in categories {
                taskGroup.addTask {
                    let categoryURL = Endpoints.productsByCategory(category: category)
                    return (category, try await self.getProductsByCategory(url: categoryURL))
                }
            }
            for try await products in taskGroup {
                categoryPreviews.append(ProductCategoryPreview(name: products.0, products: products.1))
            }
        }
        return categoryPreviews
    }
    
    func getProductsByCategory(url: URL) async throws -> [Product] {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let productsResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            return productsResponse.products
        } catch {
            print(error)
            throw ProductServiceError.emptyResponse
        }
    }
    
    func getProductImage(url: URL) async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return UIImage() }
            return image
        } catch {
            print(error)
            throw ProductServiceError.emptyResponse
        }
    }
    
    func getProductCategoryPreview(category: String) async throws -> ProductCategoryPreview {
        let categoryURL = Endpoints.productsByCategory(category: category)
        do {
            let (data,_) = try await URLSession.shared.data(from: categoryURL)
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            let productCategoryPreview = ProductCategoryPreview(name: category, products: productResponse.products)
            return productCategoryPreview
        } catch {
            print(error)
            throw ProductServiceError.emptyResponse
        }
    }
}
