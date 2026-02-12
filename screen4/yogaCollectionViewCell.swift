//
//  yogaCollectionViewCell.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

// MARK: - Delegate Protocol
protocol YogaCellDelegate: AnyObject {
    func didTapStartButton()
}

class yogaCollectionViewCell: UICollectionViewCell {

    // MARK: - Delegate
    weak var delegate: YogaCellDelegate?

    // MARK: - Outlets
    @IBOutlet weak var benefitLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // benefits label
        benefitLabel.numberOfLines = 2
        benefitLabel.lineBreakMode = .byTruncatingTail
        benefitLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        benefitLabel.setContentHuggingPriority(.required, for: .vertical)

        // card styling
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.masksToBounds = true

        // shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 4)

        // image styling
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
    }

    // MARK: - Actions
    @IBAction func startButton(_ sender: UIButton) {
        delegate?.didTapStartButton()
    }

    // MARK: - Configure
    func configureCell(yoga: Fitness) {
        nameLabel.text = yoga.name
        benefitLabel.text = yoga.benefits.joined(separator: ", ")
        levelLabel.text = yoga.level
        durationLabel.text = yoga.duration
        imageView.image = UIImage(named: yoga.imagePath)
    }
}
