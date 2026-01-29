
// SettingsVC.swift

import UIKit

class SettingsVC: UIViewController {

    // MARK: - UI Components
    private let langSwitch = LanguageSwitchView()
    
    private let logoutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Logout".localized
        config.image = UIImage(systemName: "power.circle.fill")
        config.imagePadding = 10
        config.baseBackgroundColor = .systemGray6
        config.baseForegroundColor = .systemRed
        config.cornerStyle = .capsule
        
        return UIButton(configuration: config)
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings".localized
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        setupActions()
        hideKeyboardWhenTappedAround()
    }
    
 
    private func setupAppearance() {
        view.backgroundColor = .main
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 12
        view.layer.masksToBounds = false
        
        view.layer.cornerRadius = 20
        
        titleLabel.textColor = .white
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [langSwitch, logoutButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            langSwitch.heightAnchor.constraint(equalToConstant: 45),
            logoutButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private func setupActions() {
        langSwitch.onTap = { [weak self] in
            self?.handleLanguageChange()
        }
        
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }


    private func handleLanguageChange() {
        let isArabic = LanguageManager.shared.isArabic
        LanguageManager.shared.setLanguage(isArabic ? .english : .arabic)
        
        langSwitch.updateAppearance()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            let mainTabBar = MainTabBarController()
            
            window.rootViewController = mainTabBar
            
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    @objc private func handleLogout() {
        let alert = UIAlertController(title: "Logout".localized, message: "Are you sure you want to exit?".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive, handler: { _ in
            UserDefaultsManager.shared.logout()
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.coordinator?.start()
                }
            

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        present(alert, animated: true)
    }
    private func navigateToLogin() {
         let loginVC = LoginVC()
         view.window?.rootViewController = loginVC
    }
}
