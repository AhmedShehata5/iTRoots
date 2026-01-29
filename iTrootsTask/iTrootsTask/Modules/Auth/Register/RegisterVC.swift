//
//  RegisterVC.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
     let viewModel = RegisterViewModel()
    private var isPasswordHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTableView()
        setupNavigationBarButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    var registerCell: RegisterTableViewCell? {
        return tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterTableViewCell
    }

    private func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        
        let nib = UINib(nibName: "RegisterTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "RegisterTableViewCell")
    }

    private func setupNavigationBarButtons() {
        let isArabic = LanguageManager.shared.isArabic
        let imageName = isArabic ? "chevron.right" : "chevron.left"
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(backTapped))
        backBarButton.tintColor = .main
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func showStyledAlert(message: String) {
        let alert = UIAlertController(title: "input_error".localized, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "try_again".localized, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
 
    func enableButton() {
        guard let cell = registerCell else { return }
        
        let name = cell.nameTextField.text ?? ""
        let phone = cell.phoneTextField.text ?? ""
        let email = cell.emailTextField.text ?? ""
        let password = cell.passwordTextField.text ?? ""
        
        let isNameFilled = !name.isEmpty
        let isPhoneValid = phone.count == 10
        let isEmailValid = email.contains("@") && !email.isEmpty
        let isPasswordValid = password.count >= 6
        
        let conditions = [isNameFilled, isPhoneValid, isEmailValid, isPasswordValid]
        let metConditionsCount = conditions.filter { $0 }.count
        let completionRatio = CGFloat(metConditionsCount) / CGFloat(conditions.count)
        
        UIView.animate(withDuration: 0.3) {
            cell.registerButton.alpha = metConditionsCount == conditions.count ? 1.0 : 0.6
            cell.registerButton.backgroundColor = .main.withAlphaComponent(0.4 + (0.6 * completionRatio))
        }
    }
}

// MARK: - TableView Extensions
extension RegisterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell", for: indexPath) as! RegisterTableViewCell
        
        cell.nameTextField.delegate = self
        cell.phoneTextField.delegate = self
        cell.emailTextField.delegate = self
        cell.passwordTextField.delegate = self
        
        [cell.nameTextField, cell.phoneTextField, cell.emailTextField, cell.passwordTextField].forEach {
            $0?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
 
        cell.eyeButton.addTarget(self, action: #selector(showPasswordAction), for: .touchUpInside)
        cell.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        cell.loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - TextField & Actions
extension RegisterVC: UITextFieldDelegate {
    
    @objc func textDidChange() {
        enableButton()
    }
    
    @objc func registerAction() {
        guard let cell = registerCell else { return }
        
        let result = viewModel.validateFields(
            name: cell.nameTextField.text,
            phone: cell.phoneTextField.text,
            email: cell.emailTextField.text,
            password: cell.passwordTextField.text
        )
        
        if result.isValid {
            let phone = cell.phoneTextField.text ?? ""
            
            viewModel.register(phone: phone) { [weak self] success, errorMessage in
                guard let self = self else { return }
                
                if success {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            sceneDelegate.coordinator?.showMain()
                        }
                } else {
                    self.showStyledAlert(message: errorMessage ?? "unknown_error".localized)
                    self.shakeButton(cell.registerButton)
                }
            }
        } else {
            self.showStyledAlert(message: result.message ?? "")
            shakeButton(cell.registerButton)
        }
    }
    
    func shakeButton(_ button: UIButton) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        button.layer.add(animation, forKey: "shake")
    }
    
    @objc func loginAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc func showPasswordAction(_ sender: UIButton) {
        isPasswordHidden.toggle()
        registerCell?.passwordTextField.isSecureTextEntry = isPasswordHidden
        sender.setImage(UIImage(systemName: isPasswordHidden ? "eye.slash.fill" : "eye.fill"), for: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let cell = registerCell, textField == cell.phoneTextField else { return true }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && updatedText.count <= 10
    }
}
