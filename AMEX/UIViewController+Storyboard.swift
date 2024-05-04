//
//  UIViewController+Storyboard.swift
//
//  Created by David Grigoryan
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardId: String { get }
}

extension StoryboardIdentifiable {
    static var storyboardId: String {
        get {""}
        set {}
    }
}

extension UIViewController: StoryboardIdentifiable {}
