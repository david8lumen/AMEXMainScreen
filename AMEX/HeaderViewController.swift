//
//  HeaderViewController.swift
//
//  Created by David Grigoryan
//

import UIKit

class HeaderViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cards: [Card]
    
    private let layout = CustomLayout()
    
    static var storyboardId: String {
        return "HeaderVC"
    }
    
    var itemWidthPercentage: CGFloat {
        return 0.6
    }
    
    var itemWidth: CGFloat {
        return collectionView.bounds.width * itemWidthPercentage
    }
    
    var itemRemainingWidth: CGFloat {
        return collectionView.bounds.width - itemWidth
    }
    
    var itemAspectRatio: CGFloat {
        return 3 / 4
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

        collectionView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCell")
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: itemWidth, height: collectionView.bounds.width / 2 * itemAspectRatio)
        collectionView.contentInset = .init(top: 0,
                                            left: itemRemainingWidth / 2,
                                            bottom: 0,
                                            right: 0)
    }
    
    func setContentOffset(_ offset: CGPoint, animated: Bool = false) {
        collectionView.setContentOffset(offset, animated: animated)
    }
    
    func setHorizontalOffset(x: CGFloat, animated: Bool = false) {
        collectionView.setContentOffset(.init(x: x, y: collectionView.contentOffset.y), animated: animated)
    }
    
    func setVerticalOffset(y: CGFloat, animated: Bool = false) {
        collectionView.setContentOffset(.init(x: collectionView.contentOffset.x, y: y), animated: animated)
    }
    
    func indexPathForItem(by gesture: UIGestureRecognizer) -> IndexPath? {
        let pointInHeader = gesture.location(in: collectionView)
        return collectionView.indexPathForItem(at: pointInHeader)
    }
}

extension HeaderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else { return UICollectionViewCell() }
        headerCell.contentView.layer.cornerRadius = 16
        let imageName = cards[indexPath.row].imageName
        headerCell.cardImageView.image = UIImage(named: imageName)
        return headerCell
    }
}

extension HeaderViewController {
    static let headerHeight = 200.0
}
