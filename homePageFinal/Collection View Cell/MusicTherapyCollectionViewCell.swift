//
//  MusicTherapyCollectionViewCell.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

class MusicTherapyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

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
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true    }
    
    func configureCell(musicTherapy: Mind) {
        nameLabel.text = musicTherapy.name
        imageView.image = UIImage(named: musicTherapy.imagePath)
    }

}
