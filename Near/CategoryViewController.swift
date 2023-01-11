//
//  CategoryViewController.swift
//  Near
//
//  Created by Roger Davila on 1/9/23.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController {
    var categoryPreview: ProductCategoryPreview?
    
    var categoryProducts: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = categoryPreview?.name.capitalizeText()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(categoryProducts)
        categoryProducts.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoryProducts.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoryProducts.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryProducts.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        categoryProducts.dataSource = self
        categoryProducts.delegate = self
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryPreview?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CategoryProductCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        cell.layer.cornerRadius = 12
        cell.product = categoryPreview?.products[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProductViewController()
        viewController.product = categoryPreview?.products[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

class CategoryProductCell: UICollectionViewCell {
    var product: Product? {
        didSet {
            Task {
                productImage.image = try await ProductService().getProductImage(url: URL(string: product?.thumbnail ?? "")!)
            }
            productName.text = product?.title
            productBrand.text = product?.brand
            productPrice.text = String(format: "$%.2f", product?.price ?? 0)
        }
    }
    
    var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    var verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    var productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productBrand: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productPrice: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(horizontalStack)
        
        horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        horizontalStack.addArrangedSubview(productImage)
        productImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        horizontalStack.addArrangedSubview(verticalStack)
        verticalStack.addArrangedSubview(productName)
        verticalStack.addArrangedSubview(productBrand)
        verticalStack.addArrangedSubview(productPrice)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
