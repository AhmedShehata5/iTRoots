//
//  SliderCell.swift
//  iTrootsTask
//
//  Created by Ahmed on 29/01/2026.
//

import UIKit
import SDWebImage

final class SliderCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        sliderImageView.layer.cornerRadius = 15
            sliderImageView.clipsToBounds = true
            sliderImageView.layer.masksToBounds = true
        
        titleLabel.numberOfLines = 0
        
        setupShadow(for: backView)
    }

    private func setupShadow(for view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
    }

    func configure(with item: SliderItem) {
        titleLabel.text = item.title
        sliderImageView.sd_setImage(with: URL(string: item.url), placeholderImage: UIImage(systemName: "placeholder")?.withRenderingMode(.alwaysTemplate))
        self.sliderImageView.layer.cornerRadius = 15
        self.sliderImageView.clipsToBounds = true
    }
}
