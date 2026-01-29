import UIKit

final class LoginVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var containerPhoneView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var countryImageView: UIImageView!

    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var containerPasswordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!

    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var checkRemeberButton: UIButton!
    @IBOutlet weak var remeberLabel: UILabel!

    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var dontHaveAccountTitle: UILabel!
    @IBOutlet weak var registerButton: UIButton!

    // MARK: - Properties
     let viewModel = LoginViewModel()
    private var isPasswordHidden = true
    
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
        setupConfigiration()
        setupNavigationBarButtons()
        setupLocalization()
        bindViewModel()
        [phoneTextField, passwordTextField].forEach {
                $0?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            }
            enableButton()
        phoneTextField.delegate = self
    }

    // MARK: - Setup
    private func setupUI() {
       
        let isArabic = LanguageManager.shared.isArabic
        let alignment: NSTextAlignment = isArabic ? .right : .left
            
        let attribute: UISemanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
            
            phoneTextField.semanticContentAttribute = attribute
        passwordTextField.isSecureTextEntry = true
            passwordTextField.semanticContentAttribute = attribute
            
            phoneTextField.textAlignment = alignment
            passwordTextField.textAlignment = alignment
        
        [containerPhoneView, containerPasswordView].forEach { view in
            view?.backgroundColor = .systemGray6
            view?.layer.cornerRadius = 12
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.systemGray5.cgColor
        }

        loginButtonOutlet.backgroundColor = .main
        loginButtonOutlet.setTitleColor(.white, for: .normal)
        loginButtonOutlet.layer.cornerRadius = 12
        loginButtonOutlet.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        loginButtonOutlet.layer.shadowColor = UIColor.main.cgColor
        loginButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 4)
        loginButtonOutlet.layer.shadowOpacity = 0.3
        loginButtonOutlet.layer.shadowRadius = 8

        phoneTitleLabel.textColor = .black
        passwordTitleLabel.textColor = .black
        
        registerButton.setTitleColor(.main, for: .normal)
        forgotPassword.setTitleColor(.main, for: .normal)
        
        checkRemeberButton.tintColor = .main
        checkRemeberButton.setImage(UIImage(systemName: "square"), for: .normal)
        countryCodeButton.setTitle("+20", for: .normal)
        countryCodeButton.setTitleColor(.main, for: .normal)
        
        countryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        countryImageView.layer.cornerRadius = 15
    }
    @objc private func textDidChange() {
        enableButton()
    }

    private func enableButton() {
        let phoneText = phoneTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        let isPhoneValid = phoneText.count == 10
        let isPasswordValid = passwordText.count >= 6
        
        let conditions = [isPhoneValid, isPasswordValid]
        let metCount = conditions.filter { $0 }.count
        let ratio = CGFloat(metCount) / CGFloat(conditions.count)
        
        UIView.animate(withDuration: 0.3) {
            if metCount == conditions.count {
                self.loginButtonOutlet.backgroundColor = .main
                self.loginButtonOutlet.alpha = 1.0
            } else {
                self.loginButtonOutlet.backgroundColor = UIColor.main.withAlphaComponent(0.2 + (0.4 * ratio))
                self.loginButtonOutlet.alpha = 0.6 + (0.2 * ratio)
            }
        }
    }
    
    private func setupConfigiration() {
        countryCodeButton.configuration = nil
        eyeButton.configuration = nil
        loginButtonOutlet.configuration = nil
        forgotPassword.configuration = nil
        registerButton.configuration = nil
    }
    private func setupLocalization() {
        phoneTitleLabel.text = "phone".localized
        passwordTitleLabel.text = "password".localized
        phoneTextField.placeholder = "Enter your phone".localized
        passwordTextField.placeholder = "Enter your password".localized
        remeberLabel.text = "remember_me".localized
        dontHaveAccountTitle.text = "dont_have_account".localized

        loginButtonOutlet.setTitle("login".localized, for: .normal)
        registerButton.setTitle("register".localized, for: .normal)
        forgotPassword.setTitle("forgot_password".localized, for: .normal)
    }

    private func setupNavigationBarButtons() {
        let langView = LanguageSwitchView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        langView.onTap = {
            let newLang: AppLanguage = LanguageManager.shared.isArabic ? .english : .arabic
            LanguageManager.shared.setLanguage(newLang)
        }
        let langBarButton = UIBarButtonItem(customView: langView)

        let isArabic = LanguageManager.shared.isArabic
        let imageName = isArabic ? "chevron.right" : "chevron.left"
        let backImage = UIImage(systemName: imageName)
        
        let backBarButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backTapped))
        backBarButton.tintColor = .main

        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = langBarButton
    }
 
    

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.coordinator?.showMain()
                    }
        }

        viewModel.onError = { [weak self] message in
           //self?.showAlert(message)
        }

        viewModel.onLoadingStateChange = { [weak self] isLoading in
            self?.loginButtonOutlet.isEnabled = !isLoading
        }
    }

    // MARK: - Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        let phone = phoneTextField.text ?? ""
        
        if UserDefaultsManager.shared.isUserRegistered(phone: phone) {
            UserDefaultsManager.shared.setLoggedIn(true, phone: phone)
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.coordinator?.showMain()
            }
        } else {
            self.showStyledAlert(message: "account_not_found_create_first".localized)
        }
    }
    func showStyledAlert(message: String) {
        let alert = UIAlertController(title: "alert_title".localized, message: message, preferredStyle: .alert)
        let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.main]
        let titleString = NSAttributedString(string: "input_error".localized, attributes: titleAttributes)
        alert.setValue(titleString, forKey: "attributedTitle")
        
        let action = UIAlertAction(title: "try_again".localized, style: .default)
        action.setValue(UIColor.main, forKey: "titleTextColor")
        alert.addAction(action)
        present(alert, animated: true)
    }

    func shakeButton(_ button: UIButton) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        button.layer.add(animation, forKey: "shake")
    }
    

    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordHidden.toggle()
        passwordTextField.isSecureTextEntry = isPasswordHidden
        let imageName = isPasswordHidden ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @IBAction func rememberTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.rememberMe = sender.isSelected
        let imageName = sender.isSelected ? "checkmark.square.fill" : "square"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }


    @IBAction func registerTapped(_ sender: UIButton) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.coordinator?.showRegister()
        }
    }
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

}
extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count > 10 {
                return false
            }
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isNumeric = allowedCharacters.isSuperset(of: characterSet)
            
            DispatchQueue.main.async {
                self.enableButton()
            }
            
            return isNumeric
        }
        return true
    }
}
