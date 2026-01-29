//
//  LanguageManager.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation
import UIKit

enum AppLanguage: String {
    case english = "en"
    case arabic = "ar"
}

final class LanguageManager {

    static let shared = LanguageManager()
    private let languageKey = "app_language"

    var currentLanguage: AppLanguage {
        if let saved = UserDefaults.standard.string(forKey: languageKey),
           let lang = AppLanguage(rawValue: saved) {
            return lang
        }
        return .english
    }

    var isArabic: Bool {
        currentLanguage == .arabic
    }

    func setLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)

        Bundle.setLanguage(language.rawValue)
        updateDirection(language)
        restartApp()
    }

    private func updateDirection(_ language: AppLanguage) {
        let attribute: UISemanticContentAttribute = (language == .arabic) ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        UINavigationBar.appearance().semanticContentAttribute = attribute
        
        UITabBar.appearance().semanticContentAttribute = attribute
    }

    private func restartApp() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        window.rootViewController = nil
        
        let attribute: UISemanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute = attribute
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate else { return }

        delegate.coordinator?.start()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

