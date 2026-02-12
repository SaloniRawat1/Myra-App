//
//  CategoryHeaderView.swift
//  SymptomsPage3
//
//  Created by GEU on 11/02/26.
//

import UIKit

class CategoryHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!

       var tapAction: (() -> Void)?

       override func awakeFromNib() {
           super.awakeFromNib()

           let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
           addGestureRecognizer(tap)
       }

       @objc func didTap() {
           tapAction?()
       }

       func configure(title: String, isExpanded: Bool) {
           titleLabel.text = title
           arrowImageView.image = UIImage(systemName: isExpanded ? "chevron.up" : "chevron.down")
       }
}
