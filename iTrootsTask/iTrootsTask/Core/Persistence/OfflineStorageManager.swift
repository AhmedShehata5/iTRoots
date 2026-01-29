//
//  OfflineStorageManager.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation

class OfflineStorageManager {
    static let shared = OfflineStorageManager()
    
    private let homeFileName = "home_data.json"
    private let productsFileName = "products_data.json"

    private init() {}

    // MARK: - Home Data Storage
    func saveHomeData(_ items: [HomeItem]) {
        let url = getHomeURL()
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: url)
            print("Home data saved to: \(url.lastPathComponent)")
        }
    }

    func loadHomeData() -> [HomeItem]? {
        let url = getHomeURL()
        if let data = try? Data(contentsOf: url) {
            return try? JSONDecoder().decode([HomeItem].self, from: data)
        }
        return nil
    }

    // MARK: - Products Data Storage
        func saveProductsData(_ items: [Product]) {
            let url = getProductsURL()
            if let data = try? JSONEncoder().encode(items) {
                try? data.write(to: url)
            }
        }

        func loadProductsData() -> [Product]? {
            let url = getProductsURL()
            if let data = try? Data(contentsOf: url) {
                return try? JSONDecoder().decode([Product].self, from: data)
            }
            return nil
        }


    // MARK: - Cache Management
    func clearCache() {
        let fileManager = FileManager.default
        let homePath = getHomeURL()
        let productsPath = getProductsURL()
        
        try? fileManager.removeItem(at: homePath)
        try? fileManager.removeItem(at: productsPath)
        
        print("All cache cleared successfully.")
    }

    // MARK: - Private URL Helpers
    private func getHomeURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(homeFileName)
    }

    private func getProductsURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(productsFileName)
    }
}
