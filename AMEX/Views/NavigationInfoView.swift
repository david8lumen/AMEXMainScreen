//
//  NavigationInfoView.swift
//
//  Created by David Grigoryan
//

import UIKit

class NavigationInfoView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    init(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
