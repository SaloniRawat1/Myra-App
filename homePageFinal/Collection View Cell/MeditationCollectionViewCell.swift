//
//  MeditationCollectionViewCell.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

class MeditationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var benefitsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Benefits label
        benefitsLabel.numberOfLines = 2
        benefitsLabel.lineBreakMode = .byTruncatingTail
        benefitsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        benefitsLabel.setContentHuggingPriority(.required, for: .vertical)

        // Card styling
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.masksToBounds = true

        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 4)

        // Image styling
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        
    }
    
    func configureCell(meditation: Mind) {
        imageView.image = UIImage(named: meditation.imagePath)
        benefitsLabel.text = meditation.benefits.joined(separator: ", ")
        durationLabel.text = meditation.duration
        nameLabel.text = meditation.name
    }
}
