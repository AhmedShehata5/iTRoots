//
//  ReachabilityManager.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Network

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    private let monitor = NWPathMonitor()
    private(set) var isConnected = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue.global())
    }
}
