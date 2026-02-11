//
//  MonthHeaderView.swift
//  TrackPage
//
//  Created by GEU on 07/02/26.
//

import UIKit

class MonthHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
           super.awakeFromNib()
           titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
           titleLabel.textColor = .label
       }
}
