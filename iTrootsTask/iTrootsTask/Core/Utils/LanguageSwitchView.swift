//
//  LanguageSwitchView.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import UIKit

final class LanguageSwitchView: UIView {
    
    
    // MARK: - Callback
    var onTap: (() -> Void)?

    // MARK: - UI
    private let button = UIButton(type: .system)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        setupButton()
        layoutButton()
        updateAppearance()
    }

    private func setupButton() {
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        addSubview(button)
    }
    private func layoutButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - UI Update
    func updateAppearance() {
        let isArabic = LanguageManager.shared.isArabic
        
        var config = UIButton.Configuration.filled()
        config.imagePadding = 15
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = .systemGray6
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "globe")
        
        let activeColor = UIColor.main
        let normalColor = UIColor.secondaryLabel
        let font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        var arTitle = AttributedString("AR")
        arTitle.foregroundColor = isArabic ? activeColor : normalColor
        arTitle.font = font

        var separator = AttributedString(" | ")
        separator.foregroundColor = .tertiaryLabel

        var enTitle = AttributedString("EN")
        enTitle.foregroundColor = isArabic ? normalColor : activeColor
        enTitle.font = font

        var finalTitle = arTitle
        finalTitle += separator
        finalTitle += enTitle
        
        config.attributedTitle = finalTitle
        button.configuration = config

        button.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
    }
    // MARK: - Action
    @objc private func tapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        animate {
            self.onTap?()
        }
    }

    // MARK: - Animation
    private func animate(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            }) { _ in
                completion()
            }
        }
    }
}
