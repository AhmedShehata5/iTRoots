//
//  RegisterTableViewCell.swift
//  NewBazar
//
//  Created by Ahmed on 09/01/2026.
//

import UIKit

class RegisterTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var containerNameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var containerPhoneView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var containerEmailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var containerPasswordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var haveAccountTitle: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupConfigiration()
        setupLocalization()
    }
    
    private func setupUI() {
        self.selectionStyle = .none

        let isArabic = LanguageManager.shared.isArabic
        let alignment: NSTextAlignment = isArabic ? .right : .left
            
        let attribute: UISemanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
            
            phoneTextField.semanticContentAttribute = attribute
        passwordTextField.isSecureTextEntry = true
            passwordTextField.semanticContentAttribute = attribute
        emailTextField.semanticContentAttribute = attribute
        nameTextField.semanticContentAttribute = attribute
            phoneTextField.textAlignment = alignment
            passwordTextField.textAlignment = alignment
        emailTextField.textAlignment = alignment
        nameTextField.textAlignment = alignment
        
        [containerPhoneView,containerEmailView, containerNameView, containerPasswordView].forEach { view in
            view?.backgroundColor = .systemGray6
            view?.layer.cornerRadius = 12
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.systemGray5.cgColor
        }

        registerButton.backgroundColor = .main
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        registerButton.layer.shadowColor = UIColor.main.cgColor
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        registerButton.layer.shadowOpacity = 0.3
        registerButton.layer.shadowRadius = 8

        phoneTitleLabel.textColor = .black
        passwordTitleLabel.textColor = .black
        
        registerButton.setTitleColor(.white, for: .normal)
        
        loginButton.setTitleColor(.main, for: .normal)
        countryCodeButton.setTitle("+20", for: .normal)
        countryCodeButton.setTitleColor(.main, for: .normal)
        
        countryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        countryImageView.layer.cornerRadius = 15
    }
    private func setupConfigiration() {
        countryCodeButton.configuration = nil
        eyeButton.configuration = nil
        loginButton.configuration = nil
        registerButton.configuration = nil
    }
    private func setupLocalization() {
        nameTitleLabel.text = "name".localized
        emailTitleLabel.text = "email".localized
        nameTextField.placeholder = "Enter your name".localized
        emailTextField.placeholder = "Enter your email".localized
        phoneTitleLabel.text = "phone".localized
        passwordTitleLabel.text = "password".localized
        phoneTextField.placeholder = "Enter your phone".localized
        passwordTextField.placeholder = "Enter your password".localized
        haveAccountTitle.text = "have_account".localized
        registerButton.setTitle("register".localized, for: .normal)
        loginButton.setTitle("login".localized, for: .normal)
       
     
    }

       
    }

