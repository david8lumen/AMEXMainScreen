//
//  MainViewController.swift
//
//  Created by David Grigoryan
//

import UIKit

class MainViewController: UIViewController {
    
    private var topConstraint: NSLayoutConstraint!
    
    private let cards: [Card]
    
    private lazy var headerViewController: HeaderViewController = {
        let headerViewController = children.first { $0 is HeaderViewController } as! HeaderViewController
        return headerViewController
    }()
    
    private lazy var productInfoViewController: ProductInfoViewController = {
        children.first { $0 is ProductInfoViewController } as! ProductInfoViewController
    }()
    
    private lazy var titleView: NavigationInfoView = {
        let nib = UINib(nibName: String(describing: NavigationInfoView.self), bundle: Bundle.main)
        let titleView = nib.instantiate(withOwner: nil, options: nil).first as! NavigationInfoView
        return titleView
    }()
    
    static var storyboardId: String {
        return "MainVC"
    }
    
    required init?(coder: NSCoder, cards: [Card]) {
        self.cards = cards
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
        productInfoViewController.delegate = self
        navigationItem.titleView = titleView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTitleViewByCurrentSelectedIndex()
    }
    
    private func setupChildControllers() {
        guard let storyboard else { return }
        
        let headerViewController = storyboard.instantiateViewController(identifier: HeaderViewController.storyboardId, creator: { coder in
            let headerViewController = HeaderViewController(coder: coder, cards: self.cards)
            return headerViewController
        })
        
        let productInfoViewController = storyboard.instantiateViewController(identifier: ProductInfoViewController.storyboardId) { coder in
            let productInfoViewController = ProductInfoViewController(coder: coder)
            return productInfoViewController
        }
        
        headerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        productInfoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(headerViewController)
        addChild(productInfoViewController)
        
        view.addSubview(headerViewController.view)
        view.addSubview(productInfoViewController.view)
        topConstraint = headerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            headerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewController.view.heightAnchor.constraint(equalToConstant: HeaderViewController.headerHeight),
            productInfoViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productInfoViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productInfoViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productInfoViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        headerViewController.didMove(toParent: self)
        productInfoViewController.didMove(toParent: self)
        
    }
    
    private func updateTitleViewByCurrentSelectedIndex() {
        let selectedItemIndex = productInfoViewController.currentSelectedItemIndex
        titleView.titleLabel.text = cards[selectedItemIndex].name
        titleView.subtitleLabel.text = cards[selectedItemIndex].maskedNumber
    }
}

// MARK: - ProductInfoViewControllerDelegate
extension MainViewController: ProductInfoViewControllerDelegate {
    func productViewControllerDidFinishScrollingAnimation(_ controller: ProductInfoViewController) {
        updateTitleViewByCurrentSelectedIndex()
    }
    
    func productViewController(_ controller: ProductInfoViewController, didScrollHorizontally offset: CGPoint) {
        let factor = offset.x * headerViewController.itemWidthPercentage
        let x = factor - (headerViewController.itemRemainingWidth / 2)
        headerViewController.setHorizontalOffset(x: x)
    }
    
    func productViewController(_ controller: ProductInfoViewController, didScrollVertically offset: CGPoint) {
        topConstraint.constant = min(-offset.y - HeaderViewController.headerHeight, 0)
    }
    
    func productViewController(_ controller: ProductInfoViewController, didTapCollectionView gesture: UITapGestureRecognizer) {
        guard let headerItemIndexPath = headerViewController.indexPathForItem(by: gesture) else { return }
        productInfoViewController.selectItem(at: headerItemIndexPath.row)
    }
}
