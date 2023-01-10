//
//  ViewController.swift
//  Near
//
//  Created by Roger Davila on 1/1/23.
//

import UIKit

class HomeViewController: UIViewController {
    var categories: [ProductCategoryPreview] = [
        ProductCategoryPreview(name: "Men's"),
        ProductCategoryPreview(name: "Women's"),
        ProductCategoryPreview(name: "Groceries"),
        ProductCategoryPreview(name: "Technology"),
        ProductCategoryPreview(name: "Smartphones"),
        ProductCategoryPreview(name: "Televisions"),
    ]
    var categoryPreviews: [ProductCategoryPreview] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Trending"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Task {
            let categories = try await ProductService().getProductCategories(url: Endpoints.productCategories)
            let previewProducts = try await ProductService().getProductCategoryPreviews(categories: categories)
            categoryPreviews.append(contentsOf: previewProducts)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryPreviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PreviewCell
        cell.categoryPreview = self.categoryPreviews[indexPath.row]
        cell.navigationController = navigationController // Allows for access of the navigationController in the sub collection
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16, height: 300)
    }
}

class PreviewCell: UICollectionViewCell, UICollectionViewDelegate {
    // Allows for access of the view controller from the main window by passing it down
    var navigationController: UINavigationController?
    
    var categoryPreview: ProductCategoryPreview? {
        didSet {
            guard let categoryPreview = categoryPreview else { return }
            categoryName.text = categoryPreview.name.capitalizeText()
            collectionView.reloadData()
        }
    }
    
    var categoryName: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return textLabel
    }()
    
    var seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See All >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "Product Cell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        seeAllButton.addTarget(self, action: #selector(didSelectCategory(_:)), for: .touchUpInside)
        
        contentView.addSubview(categoryName)
        categoryName.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        contentView.addSubview(seeAllButton)
        seeAllButton.topAnchor.constraint(equalTo: categoryName.topAnchor).isActive = true
        seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
  
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: seeAllButton.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSelectCategory(_ sender: UIButton) {
        let categoryViewController = CategoryViewController()
        categoryViewController.categoryPreview = categoryPreview
        print(categoryPreview?.name ?? "")
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
}

extension PreviewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let products = categoryPreview?.products else { return 0 }
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Product Cell", for: indexPath) as! ProductCell
        cell.product = categoryPreview?.products[indexPath.row]
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 12
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProductViewController()
        viewController.product = categoryPreview?.products[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

class ProductCell: UICollectionViewCell, UICollectionViewDelegate {
    var product: Product? {
        didSet {
            // Get thumbnail image
            Task {
                productImage.image = try await ProductService().getProductImage(url: URL(string: product?.thumbnail ?? "")!)
            }
            productName.text = product?.title
            productPrice.text = String(format: "$%.2f", product?.price ?? 0)
        }
    }
    
    var productName: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    var productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    var productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productImage)
        productImage.widthAnchor.constraint(equalToConstant: 170).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        contentView.addSubview(productName)
        productName.topAnchor.constraint(equalTo: productImage.bottomAnchor).isActive = true
        productName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(productPrice)
        productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
