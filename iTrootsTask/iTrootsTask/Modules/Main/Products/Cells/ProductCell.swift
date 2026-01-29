//
//  ProductCell.swift
//  iTrootsTask
//
//  Created by Ahmed on 29/01/2026.
//



import UIKit
import SDWebImage

class ProductCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prodictImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupShadow(for: backView)
    }

    private func setupShadow(for view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }

    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .main
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        priceLabel.font = .boldSystemFont(ofSize: 15)
        priceLabel.textColor = .systemGreen
        
        categoryLabel.font = .systemFont(ofSize: 12, weight: .medium)
        categoryLabel.textColor = .main
        
        prodictImage.layer.cornerRadius = 8
        prodictImage.contentMode = .scaleAspectFit
        prodictImage.clipsToBounds = true
        
        selectionStyle = .none
    }

    func configure(with product: Product) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = "\(product.price) $"
        categoryLabel.text = product.category.uppercased()
        
        if let imageUrl = URL(string: product.image) {
            prodictImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        let isArabic = LanguageManager.shared.isArabic
        let alignment: NSTextAlignment = isArabic ? .right : .left
        
        titleLabel.textAlignment = alignment
        descriptionLabel.textAlignment = alignment
        priceLabel.textAlignment = alignment
        categoryLabel.textAlignment = alignment
    }
}
