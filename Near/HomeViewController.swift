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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .brown
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Task {
            let categories = try await ProductService().getProductCategories(url: Endpoints.productCategories)
            print(self.categories.count)
            let previewProducts = try await ProductService().getProductCategoryPreviews(categories: categories)
            categoryPreviews.append(contentsOf: previewProducts)
            print(previewProducts)
            print(categoryPreviews.count)

            for products in previewProducts {
                print("\(products.name)")
                for product in products.products {
                    print("\(product.title)")
                }
            }
            
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
        cell.navigationController = navigationController
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
}

class PreviewCell: UICollectionViewCell, UICollectionViewDelegate {
    // Allows for access of the view controller from the main window by passing it down
    var navigationController: UINavigationController?
    
    var categoryPreview: ProductCategoryPreview? {
        didSet {
            guard let categoryPreview = categoryPreview else { return }
            cellLabel.text = categoryPreview.name
            collectionView.reloadData()
        }
    }
    
    var cellLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
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
        
        contentView.addSubview(cellLabel)
        cellLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
  
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .cyan
        collectionView.topAnchor.constraint(equalTo: cellLabel.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = categoryPreview?.products[indexPath.row]
        print("Selected \(data?.title ?? "")")
        let vc = ProductViewController()
        vc.product = categoryPreview?.products[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

class ProductCell: UICollectionViewCell, UICollectionViewDelegate {
    var product: Product? {
        didSet {
            productName.text = product?.title
        }
    }
    
    var productName: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productName)
        productName.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
