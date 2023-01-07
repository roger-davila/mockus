//
//  ViewController.swift
//  Near
//
//  Created by Roger Davila on 1/1/23.
//

import UIKit

class HomeViewController: UIViewController {
    var categories: [String] = ["Cat1","Cat2","Cat3","Cat4","Cat5","Cat6"]
    var categoryPreviews: [ProductCategoryPreview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemPink
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemCyan
        stackView.spacing = 20
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        
        
//        Task {
//            let categories = try await ProductService().getProductCategories(url: Endpoints.productCategories)
//            self.categories.append(contentsOf: categories)
//            print(self.categories.count)
//            let previewProducts = try await ProductService().getProductCategoryPreviews(categories: self.categories)
//            print(previewProducts)
//            print(previewProducts.count)
//            for category in categories {
//                stackView.addArrangedSubview(cardView(category: category))
//            }
//        }
        
        for category in categories {
            stackView.addArrangedSubview(cardView(category: category))
        }
    }
    
    private func scrollListLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func cardView(category: String) -> UIView {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        cardView.backgroundColor = .systemBlue
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 1.0
        cardView.layer.shadowOpacity = 0.7
        
        let textLabel = UILabel()
        textLabel.text = category
        textLabel.textColor = .black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(textLabel)
        
        return cardView
    }
}

