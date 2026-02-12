//
//  exceriseCollectionViewCell.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

class exceriseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var benefitLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        benefitLabel.numberOfLines = 2
        // Benefits label
            benefitLabel.numberOfLines = 2
            benefitLabel.lineBreakMode = .byTruncatingTail

            // Card styling
            contentView.layer.cornerRadius = 16
            contentView.backgroundColor = .secondarySystemBackground
            contentView.layer.masksToBounds = true

            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.06
            layer.shadowRadius = 10
            layer.shadowOffset = CGSize(width: 0, height: 6)
            layer.masksToBounds = false

            // 🔥 IMAGE FIX (MOST IMPORTANT PART)
        imageView.contentMode = .scaleAspectFit
                imageView.backgroundColor = .secondarySystemBackground
                imageView.layer.cornerRadius = 12
                imageView.clipsToBounds = true
                imageView.isOpaque = false

    }

    @IBAction func startButton(_ sender: Any) {
    }
    
    func configureCell(excercise: Fitness){
        nameLabel.text = excercise.name
        levelLabel.text = excercise.level
        durationLabel.text = excercise.duration
        benefitLabel.text = excercise.benefits.joined(separator: ", ")
        imageView.image = UIImage(named: excercise.imagePath)
    }
    
}
