//
//  CollectionCell.swift
//
//  Created by David Grigoryan
//

import UIKit

protocol CollectionCellDelegate: AnyObject {
    func collectionCell(_ collectionCell: CollectionCell, tableViewDidScrollWithOffset offset: CGPoint)
}

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: CollectionCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        tableView.contentInset = .init(top: HeaderViewController.headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset.y = -HeaderViewController.headerHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    func resetTableViewOffset() {
        tableView.contentOffset.y = -HeaderViewController.headerHeight
    }
}

extension CollectionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Label \(indexPath.row + 1)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.collectionCell(self, tableViewDidScrollWithOffset: scrollView.contentOffset)
    }
}
