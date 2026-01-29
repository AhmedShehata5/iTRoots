//
//  HomeViewModel.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//


//
//  HomeViewModel.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Properties
    var sliderItems: [SliderItem] = []
    var homeItems: [HomeItem] = []
    
    // MARK: - Callbacks
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Public Methods
    func loadData() {
        print("Attempting to load data...")
        
        APIService.shared.fetchHomeData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                print("Successfully fetched \(items.count) items")
                OfflineStorageManager.shared.saveHomeData(items)
                self.processItems(items)
                self.onDataUpdated?()
                
            case .failure(let error):
                print("Request failed, checking Cache. Error: \(error.localizedDescription)")
                
                let message = NetworkManager.shared.isConnected ?
                "server_error_showing_cached_data".localized :
                "no_internet_showing_cached_data".localized
                
                self.onError?(message)
                
                self.loadFromCache()
            }
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func processItems(_ items: [HomeItem]) {
        self.sliderItems = items.prefix(5).map { item in
            let fallbackUrl = "https://picsum.photos/seed/\(item.id)/800/500"
            return SliderItem(id: item.id, title: item.title, url: fallbackUrl)
        }
        
        self.homeItems = items.prefix(50).map { item in
            let fallbackThumb = "https://picsum.photos/seed/\(item.id)/200/200"
            return HomeItem(
                id: item.id,
                albumId: item.albumId,
                title: item.title,
                url: item.url,
                thumbnailUrl: fallbackThumb
            )
        }
    }
    
    private func loadFromCache() {
        if let cached = OfflineStorageManager.shared.loadHomeData() {
            print("Found cached data! (Items: \(cached.count))")
            processItems(cached)
            self.onDataUpdated?()
        } else {
            print("No cache found!")
        }
    }
}
