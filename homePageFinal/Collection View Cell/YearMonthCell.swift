//
//  YearMonthCell.swift
//  TrackPage
//
//  Created by GEU on 07/02/26.
//

import UIKit

class YearMonthCell: UICollectionViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        monthLabel.textAlignment = .center
    }
    
    func configure(isSelected: Bool) {
        if isSelected {
            backgroundColor = UIColor.systemMint
            monthLabel.textColor = UIColor.label
        } else {
            backgroundColor = UIColor.secondarySystemBackground
            monthLabel.textColor = UIColor.label
        }
    }
}
