//
//  Card.swift
//
//  Created by David Grigoryan
//

import Foundation

struct Card: Decodable {
    let imageName: String
    let name: String
    let maskedNumber: String
}
