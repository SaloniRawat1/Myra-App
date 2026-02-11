//
//  MonthCell.swift
//  TrackPage
//
//  Created by GEU on 07/02/26.
//

import UIKit

class MonthCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
        dayLabel.textAlignment = .center
                dayLabel.textColor = .label

                contentView.backgroundColor = .systemGray6
                contentView.clipsToBounds = true
        }

    override func layoutSubviews() {
            super.layoutSubviews()
            // Always keep it circular
            contentView.layer.cornerRadius = contentView.frame.width / 2
        }

        override func prepareForReuse() {
            super.prepareForReuse()

            contentView.backgroundColor = .systemGray6
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
            dayLabel.textColor = .label
        }

    func configure(
        day: Int,
        isPeriod: Bool = false,
        isPredicted: Bool = false,
        isFertile: Bool = false
    ) {

        dayLabel.text = "\(day)"

        if isPeriod {
            // Logged period → filled pink
            contentView.backgroundColor = .systemPink
            contentView.layer.borderWidth = 0
            dayLabel.textColor = .white
        }
        
        else if isFertile {
            // Fertile window → green
            contentView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
            contentView.layer.borderWidth = 0
            dayLabel.textColor = .label
        }
        
        else if isPredicted {
            // Future prediction → outline
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 1.5
            contentView.layer.borderColor = UIColor.systemPink.cgColor
            dayLabel.textColor = .label
        }
        
        else {
            // Normal day
            contentView.backgroundColor = .systemGray6
            contentView.layer.borderWidth = 0
            dayLabel.textColor = .label
        }

        contentView.layer.cornerRadius = 8
    }

}
