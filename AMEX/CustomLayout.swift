//
//  CustomLayout.swift
//
//  Created by David Grigoryan
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    
    private var attributesList = [UICollectionViewLayoutAttributes]()
    
    
    override func prepare() {
        super.prepare()
        guard attributesList.isEmpty else { return }
        let itemsCount = collectionView!.numberOfItems(inSection: 0)
        for i in 0..<itemsCount {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let xPos: CGFloat = CGFloat(i) * itemSize.width
            let topInset = (collectionView!.bounds.height - itemSize.height) / 2
            attributes.frame = .init(x: xPos, y: topInset, width: itemSize.width, height: itemSize.height)
            attributesList.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        for (i, attribute) in attributesList.enumerated() {
            let normScale = scale(at: i)
            let scale = 1 - abs(normScale)
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return attributesList
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func scale(at index: Int) -> CGFloat {
        let frame = attributesList[index].frame
        let scale = scale(for: frame)
        return scale.normalized
    }
    
    func scale(for frame: CGRect) -> CGFloat {
        let criticalOffset = 1000.0
        let centerOffset = offsetFromScreenCenter(frame)
        let relativeOffset = centerOffset / criticalOffset
        return relativeOffset
    }
    
    func offsetFromScreenCenter(_ frame: CGRect) -> CGFloat {
        return frame.midX - collectionView!.screenCenterXOffset()
    }
}

extension CGFloat {
    var normalized: CGFloat {
        return CGFloat.minimum(1, CGFloat.maximum(-1, self))
    }
}

extension UIScrollView {
    func screenCenterXOffset(for offset: CGPoint? = nil) -> CGFloat {
        let offsetX = offset?.x ?? contentOffset.x
        let contentOffsetX = offsetX + bounds.width / 2
        return contentOffsetX
    }
}
