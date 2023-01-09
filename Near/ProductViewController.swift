//
//  File.swift
//  Near
//
//  Created by Roger Davila on 1/7/23.
//

import Foundation
import UIKit

class ProductViewController: UIViewController {
    var product: Product? {
        didSet {
            productDescription.text = product?.description
            productName.text = product?.title
            productPrice.text = String(format: "$%.2f", product?.price ?? 0)
            productRating.text = "Rating: \(product?.rating.description ?? "N/A")/5"
            Task {
                try await getImage()
            }
        }
    }
    
    var productRating: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.contentMode = .scaleAspectFit
        productImage.clipsToBounds = true
        return productImage
    }()
    
    var productDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        view.addSubview(productImage)
        view.addSubview(productName)
        view.addSubview(productPrice)
        view.addSubview(productDescription)
        view.addSubview(productRating)
        
        productImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        productName.topAnchor.constraint(equalTo: productImage.bottomAnchor).isActive = true
        productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor).isActive = true
        productRating.topAnchor.constraint(equalTo: productPrice.bottomAnchor).isActive = true
        
        productDescription.topAnchor.constraint(equalTo: productRating.bottomAnchor).isActive = true
        productDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        productDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        productDescription.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    }
    
    func getImage() async throws {
        productImage.image = try await ProductService().getProductImage(url: URL(string: product?.images[0] ?? "")!)
    }
}
