//
//  MainTabBarController.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import UIKit
import SideMenu

final class MainTabBarController: UITabBarController {
    static var lastSelectedIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
        hideKeyboardWhenTappedAround()
        self.delegate = self
        self.selectedIndex = MainTabBarController.lastSelectedIndex
    }
    private func setupAppearance() {
        tabBar.tintColor = .main
        tabBar.unselectedItemTintColor = .systemGray

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .main
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UINavigationBar.appearance().tintColor = .white
    }

    private func setupTabs() {
        let homeVC = HomeVC()
        let homeNav = UINavigationController(rootViewController: homeVC)
        setupItemNavigationBar(for: homeVC)
        
        homeNav.tabBarItem = UITabBarItem(
            title: "Home".localized,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        
        )

        let productsVC = ProductsVC()
        let productsNav = UINavigationController(rootViewController: productsVC)
        setupItemNavigationBar(for: productsVC)
        
        productsNav.tabBarItem = UITabBarItem(
            title: "Products".localized,
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle")
        )

        viewControllers = [homeNav, productsNav]
    }
    
    private func setupItemNavigationBar(for viewController: UIViewController) {
            let menuButton = UIBarButtonItem(
                image: UIImage(systemName: "line.horizontal.3"),
                style: .plain,
                target: self,
                action: #selector(menuButtonTapped)
            )
        menuButton.tintColor = .white
                viewController.navigationItem.leftBarButtonItem = menuButton
    }

    @objc private func menuButtonTapped() {
        let settingsVC = SettingsVC()
        settingsVC.modalPresentationStyle = .popover
        settingsVC.preferredContentSize = CGSize(width: 250, height: 180)
        
        if let popover = settingsVC.popoverPresentationController {
            if let currentNav = selectedViewController as? UINavigationController {
                popover.barButtonItem = currentNav.visibleViewController?.navigationItem.leftBarButtonItem
            }
            
            popover.permittedArrowDirections = .up
            popover.delegate = self
            popover.backgroundColor = .main
        }
        
        present(settingsVC, animated: true)
    }
    private func showSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SettingsVC())
        menu.leftSide = true
        menu.menuWidth = view.frame.width * 0.7
        present(menu, animated: true, completion: nil)
    }
}
extension MainTabBarController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        MainTabBarController.lastSelectedIndex = tabBarController.selectedIndex
    }
}
