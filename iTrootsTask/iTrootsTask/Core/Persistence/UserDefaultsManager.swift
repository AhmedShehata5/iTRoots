//
//  UserDefaultsManager.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//


import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let loggedInKey = "isLoggedIn"
    private let currentUserPhoneKey = "userPhone"
    private let registeredUsersKey = "registeredUsers"

    func setLoggedIn(_ value: Bool, phone: String? = nil) {
        UserDefaults.standard.set(value, forKey: loggedInKey)
        if let phone = phone {
            UserDefaults.standard.set(phone, forKey: currentUserPhoneKey)
        }
    }

    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: loggedInKey)
    }

    func saveNewUser(phone: String) {
        var users = getAllRegisteredUsers()
        if !users.contains(phone) {
            users.append(phone)
            UserDefaults.standard.set(users, forKey: registeredUsersKey)
        }
    }

    func isUserRegistered(phone: String) -> Bool {
        return getAllRegisteredUsers().contains(phone)
    }

    private func getAllRegisteredUsers() -> [String] {
        return UserDefaults.standard.stringArray(forKey: registeredUsersKey) ?? []
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: loggedInKey)
        UserDefaults.standard.removeObject(forKey: currentUserPhoneKey)
    }
}
