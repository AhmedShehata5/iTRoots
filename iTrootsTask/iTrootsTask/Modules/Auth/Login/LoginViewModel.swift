//
//  LoginViewModel.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation

final class LoginViewModel {

    // MARK: - Inputs
    var phone: String = ""
    var password: String = ""
    var rememberMe: Bool = false

    // MARK: - Outputs
    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    
    func validateFields() -> (isValid: Bool, message: String?) {
            if phone.isEmpty {
                return (false, "err_phone_empty".localized)
            }
            if phone.count != 10 {
                return (false, "err_phone_invalid".localized)
            }
            if password.isEmpty {
                return (false, "err_password_empty".localized)
            }
            if password.count < 6 {
                return (false, "err_password_short".localized)
            }
            return (true, nil)
        }
    

    func login(completion: @escaping (Bool, String?) -> Void) {
        if UserDefaultsManager.shared.isUserRegistered(phone: phone) {
            UserDefaultsManager.shared.setLoggedIn(true, phone: phone)
            completion(true, nil)
        } else {
            completion(false, "account_not_found_create_first".localized)
        }
    }
}
