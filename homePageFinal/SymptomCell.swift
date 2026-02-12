//
//  SymptomCell.swift
//  SymptomsPage3
//
//  Created by GEU on 11/02/26.
//

import UIKit

class SymptomCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .systemGray5
    }


    func configure(with symptom: Symptom) {
        titleLabel.text = symptom.name
        
        UIView.animate(withDuration: 0.2) {
            if symptom.isSelected {
                self.containerView.backgroundColor = .systemTeal
                self.titleLabel.textColor = .white
            } else {
                self.containerView.backgroundColor = .systemGray5
                self.titleLabel.textColor = .black
            }
        }
    }

}
