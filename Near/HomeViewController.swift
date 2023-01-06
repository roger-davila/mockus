//
//  ViewController.swift
//  Near
//
//  Created by Roger Davila on 1/1/23.
//

import UIKit

class HomeViewController: UIViewController {
    var categories: [String] = []
    var categoryPreviews: [ProductCategoryPreview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        // Do any additional setup after loading the view.
        
        Task {
            let categories = try await ProductService().getProductCategories(url: Endpoints.productCategories)
            self.categories.append(contentsOf: categories)
            print(self.categories.count)
            let previewProducts = try await ProductService().getProductCategoryPreviews(categories: self.categories)
            print(previewProducts)
            print(previewProducts.count)
        }
    }
    
    private func scrollListLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

