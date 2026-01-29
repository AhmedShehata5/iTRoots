//
//  Product.swift
//  iTrootsTask
//
//  Created by Ahmed on 29/01/2026.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String

    
    enum CodingKeys: String, CodingKey {
        case id, title, price, description, category, image
    }
}
