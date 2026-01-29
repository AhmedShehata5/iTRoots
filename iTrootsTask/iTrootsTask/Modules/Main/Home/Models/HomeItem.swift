//
//  HomeItem.swift
//  iTrootsTask
//
//  Created by Ahmed on 29/01/2026.
//

import Foundation

struct HomeItem: Codable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
