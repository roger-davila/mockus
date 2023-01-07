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
    
    private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .brown
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
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
        
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .systemPink
//
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .systemCyan
//        stackView.spacing = 20
//
//        scrollView.addSubview(stackView)
//        view.addSubview(scrollView)
//        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalToConstant: 210).isActive = true
//
//        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        
        
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
        
//        for category in categories {
//            verticalStackView.addArrangedSubview(cardView(category: category))
//        }
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

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PreviewCell
        cell.categoryPreview = categories[indexPath.row]
        cell.backgroundColor = .red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
}

class PreviewCell: UICollectionViewCell {
    var categoryPreview: ProductCategoryPreview? {
        didSet {
            guard let categoryPreview = categoryPreview else { return }
            cellLabel.text = categoryPreview.name
        }
    }
    
    var cellLabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellLabel)
        cellLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
