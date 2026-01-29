//
//  AppDelegate.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let savedLanguage = LanguageManager.shared.currentLanguage
            
            Bundle.setLanguage(savedLanguage.rawValue)
            
            let attribute: UISemanticContentAttribute = (savedLanguage == .arabic) ? .forceRightToLeft : .forceLeftToRight
            UIView.appearance().semanticContentAttribute = attribute
            UINavigationBar.appearance().semanticContentAttribute = attribute
            
            return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      
    }


}

