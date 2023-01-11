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
            productBrandAndCategory.text = "\(product?.brand ?? "") - \(product?.category.capitalizeText() ?? "")"
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
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    var productBrandAndCategory: UILabel = {
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
        productImage.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        productImage.contentMode = .scaleAspectFit
        productImage.clipsToBounds = true
        return productImage
    }()
    
    var productDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        return textView
    }()
    
    var verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Description"
        
        view.addSubview(productImage)
        view.addSubview(verticalStack)
        view.backgroundColor = .white
        
        verticalStack.addArrangedSubview(productName)
        verticalStack.addArrangedSubview(productPrice)
        verticalStack.addArrangedSubview(productBrandAndCategory)
        verticalStack.addArrangedSubview(productDescription)
        verticalStack.addArrangedSubview(productRating)
        
        verticalStack.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        productImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        verticalStack.topAnchor.constraint(equalTo: productImage.bottomAnchor).isActive = true
    }
    
    func getImage() async throws {
        productImage.image = try await ProductService().getProductImage(url: URL(string: product?.images[0] ?? "")!)
    }
}
