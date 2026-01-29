//
//  NetworkManager.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation
import Network

final class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
            print("Internet Status Updated: \(self?.isConnected ?? false)")
        }
        monitor.start(queue: queue)
    }

    func checkCurrentStatus() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
}
