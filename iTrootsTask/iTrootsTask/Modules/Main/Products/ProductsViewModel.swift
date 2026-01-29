//
//  ProductsViewModel.swift
//  iTrootsTask
//
//  Created by Ahmed on 29/01/2026.
//

import Foundation

class ProductsViewModel {
    
    private(set) var products: [Product] = []
    var onError: ((String) -> Void)?
    
    func fetchProducts(completion: @escaping () -> Void) {
        print("🔍 Checking Internet Status...")
        
        if !NetworkManager.shared.checkCurrentStatus() {
            print("⏳ Internet seems OFF, waiting for a second chance...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.executeFetch(completion: completion)
            }
        } else {
            executeFetch(completion: completion)
        }
    }
    
    private func executeFetch(completion: @escaping () -> Void) {
        if NetworkManager.shared.checkCurrentStatus() {
            print("✅ Internet is ON, fetching from API...")
            APIService.shared.fetchProducts { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    print("✅ Successfully fetched \(items.count) products")
                    self.products = items
                    OfflineStorageManager.shared.saveProductsData(items)
                    completion()
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    self.loadOfflineData(message: "server_error".localized)
                    completion()
                }
            }
        } else {
            print("⚠️ Still OFF, loading offline data.")
            self.loadOfflineData(message: "no_internet_connection".localized)
            completion()
        }
    }
    
    private func loadOfflineData(message: String) {
        self.onError?(message)
        if let cachedData = OfflineStorageManager.shared.loadProductsData() {
            self.products = cachedData
        }
    }


    
    private func handleError(_ message: String) {
        self.onError?(message)
        if let cached = OfflineStorageManager.shared.loadProductsData() {
            self.products = cached
        }
    }
}
