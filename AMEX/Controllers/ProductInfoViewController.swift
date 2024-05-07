//
//  ViewController.swift
//
//  Created by David Grigoryan
//

import UIKit

protocol ProductInfoViewControllerDelegate: AnyObject {
    func productViewController(_ controller: ProductInfoViewController, didScrollHorizontally offset: CGPoint)
    func productViewController(_ controller: ProductInfoViewController, didScrollVertically offset: CGPoint)
    func productViewController(_ controller: ProductInfoViewController, didTapCollectionView gesture: UITapGestureRecognizer)
    func productViewControllerDidFinishScrollingAnimation(_ controller: ProductInfoViewController)
}

extension ProductInfoViewControllerDelegate {
    func productViewController(_ controller: ProductInfoViewController, didScrollHorizontally offset: CGPoint) {}
    func productViewController(_ controller: ProductInfoViewController, didScrollVertically offset: CGPoint) {}
    func productViewController(_ controller: ProductInfoViewController, didTapCollectionView gesture: UITapGestureRecognizer) {}
    func productViewControllerDidFinishScrollingAnimation(_ controller: ProductInfoViewController) {}
}

class ProductInfoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: ProductInfoViewControllerDelegate?
    
    static var storyboardId: String {
        return "ProductInfoVC"
    }
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    let layout = UICollectionViewFlowLayout()
    
    var currentSelectedItemIndex: Int {
        let itemWidth = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        let spacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let selectedIndex = collectionView.contentOffset.x / (itemWidth + spacing)
        return Int(selectedIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .init(rawValue: 0)
        
//        feedbackGenerator.prepare()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(plainCollectionTapped))
        tapGesture.delegate = self
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    @objc func plainCollectionTapped(gesture: UITapGestureRecognizer) {
        delegate?.productViewController(self, didTapCollectionView: gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout.itemSize = .init(width: collectionView.bounds.width, height: collectionView.bounds.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 8, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductInfoViewController: UICollectionViewDelegate {
    
    func centerPlain(offset: CGPoint) {
        let itemWidth = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        let spacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let totalWidth = itemWidth + spacing
        let offsetX = offset.x
        let halfOfSpacing = spacing / 2
        
        let rawIndex = floor(((offsetX + halfOfSpacing) / totalWidth) + 0.5)
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let boundedIndex = max(0, min(Int(rawIndex), numberOfItems - 1))
        let offset = (CGFloat(boundedIndex) * (itemWidth + spacing))
        
        collectionView.setContentOffset(.init(x: offset,
                                                   y: collectionView.contentOffset.y),
                                             animated: true)
    }
    
    func finishScrolling(scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).x * -1
        let itemWidth = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        let spacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let finalHalfedItemWidth = itemWidth * 0.6 + spacing
        var newXPos = 0.0
        
        if velocity > 0 {
            newXPos = collectionView.contentOffset.x + finalHalfedItemWidth
        } else {
            newXPos = collectionView.contentOffset.x - finalHalfedItemWidth
        }
        
        centerPlain(offset: .init(x: newXPos, y: collectionView.contentOffset.y))
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        finishScrolling(scrollView: scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        haptic.impactOccurred()
        delegate?.productViewControllerDidFinishScrollingAnimation(self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            finishScrolling(scrollView: scrollView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.productViewController(self, didScrollHorizontally: scrollView.contentOffset)
        let visibleCollectionCells = collectionView.visibleCells as? [CollectionCell]
        visibleCollectionCells?.forEach { $0.resetTableViewOffset() }
    }
    
    func selectItem(at index: Int) {
        let itemWidth = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        let spacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let newXPos = (CGFloat(index) * (itemWidth + spacing))
        let offset = CGPoint(x: newXPos, y: collectionView.contentOffset.y)
        collectionView.setContentOffset(offset, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCell", for: indexPath) as! CollectionCell
        cell.delegate = self
        return cell
    }
}


// MARK: - UIGestureRecognizerDelegate
extension ProductInfoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - CollectionCellDelegate
extension ProductInfoViewController: CollectionCellDelegate {
    func collectionCell(_ collectionCell: CollectionCell, tableViewDidScrollWithOffset offset: CGPoint) {
        delegate?.productViewController(self, didScrollVertically: offset)
    }
}
