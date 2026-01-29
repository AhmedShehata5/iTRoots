//
//  AppCoordinator.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        if UserDefaultsManager.shared.isLoggedIn() {
            showMain()
        } else {
            showLogin()
        }
    }

    func showLogin() {
        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
        
        loginVC.viewModel.onLoginSuccess = { [weak self] in
            self?.showMain()
        }
        
        let nav = UINavigationController(rootViewController: loginVC)
        nav.isNavigationBarHidden = true
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func showRegister() {
        guard let nav = window.rootViewController as? UINavigationController else { return }
        
        let registerVC = RegisterVC(nibName: "RegisterVC", bundle: nil)
        
        registerVC.viewModel.onRegisterSuccess = { [weak self] in
            self?.showMain()
        }
        
        nav.pushViewController(registerVC, animated: true)
    }
    func showMain() {
        DispatchQueue.main.async {
            let mainTabBar = MainTabBarController()
            
            self.window.rootViewController = mainTabBar
            
            self.window.makeKeyAndVisible()

            UIView.transition(
                with: self.window,
                duration: 0.4,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
    }
}
