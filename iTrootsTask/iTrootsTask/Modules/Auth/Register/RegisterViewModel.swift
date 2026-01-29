//
//  RegisterViewModel.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation

class RegisterViewModel {
    var onRegisterSuccess: (() -> Void)?

    func validateFields(name: String?, phone: String?, email: String?, password: String?) -> (isValid: Bool, message: String?) {
        
        if name?.isEmpty ?? true {
            return (false, "err_name_empty".localized)
        }
        
        let phoneText = phone ?? ""
            if phoneText.isEmpty {
                return (false, "err_phone_empty".localized)
            }
        
        if phoneText.count != 10 {
                return (false, "err_phone_invalid".localized)
            }
        
        if email?.isEmpty ?? true {
            return (false, "err_email_empty".localized)
        }
        
        if !(email?.contains("@") ?? false) {
            return (false, "err_email_invalid".localized)
        }
        
        if password?.isEmpty ?? true {
            return (false, "err_password_empty".localized)
        }
        
        if (password?.count ?? 0) < 6 {
            return (false, "err_password_short".localized)
        }
        
        return (true, nil)
    }
    

    func register(phone: String, completion: @escaping (Bool, String?) -> Void) {
        if UserDefaultsManager.shared.isUserRegistered(phone: phone) {
            completion(false,"account_already_registered".localized)
        } else {
            UserDefaultsManager.shared.saveNewUser(phone: phone)
            UserDefaultsManager.shared.setLoggedIn(true, phone: phone)
            
            self.onRegisterSuccess?()
            
            completion(true, nil)
        }
    }
}
