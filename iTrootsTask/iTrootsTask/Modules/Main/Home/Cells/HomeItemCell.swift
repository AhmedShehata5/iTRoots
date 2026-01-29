//
//  HomeItemCell.swift
//  iTrootsTask
//
//  Created by Ahmed on 29/01/2026.
//

import UIKit
import SDWebImage
final class HomeItemCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImageView.layer.cornerRadius = 8
        itemImageView.clipsToBounds = true
        
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        setupShadow(for: backView)
        
        selectionStyle = .none
    }

    private func setupShadow(for view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }
    func configure(with item: HomeItem) {
        titleLabel.text = item.title
        descriptionLabel.text = "ID: \(item.id)"
        itemImageView.sd_setImage(with: URL(string: item.thumbnailUrl), placeholderImage: UIImage(systemName: "placeholder"))
    }
}
