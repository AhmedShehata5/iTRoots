//
//  Validators.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation

struct Validators {

    static func isValidPhone(_ phone: String) -> Bool {
        return phone.count >= 8
    }

    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
