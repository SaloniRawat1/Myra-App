import UIKit

class MonthCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    // This is the view that will show the small red/pink circle
    var selectionCircleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell() {
        // 1. Clear backgrounds so we don't have those gray boxes
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        // 2. Create the Selection Circle View programmatically
        selectionCircleView = UIView()
        selectionCircleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(selectionCircleView, belowSubview: dayLabel)
        
        // 3. Center the circle and the label
        NSLayoutConstraint.activate([
            selectionCircleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionCircleView.widthAnchor.constraint(equalToConstant: 34), // Small circle size
            selectionCircleView.heightAnchor.constraint(equalToConstant: 34),
            
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        selectionCircleView.layer.cornerRadius = 17 // Half of 34
        selectionCircleView.clipsToBounds = true
        dayLabel.textAlignment = .center
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        selectionCircleView.backgroundColor = .clear
        selectionCircleView.layer.borderWidth = 0
        dayLabel.textColor = .label
        self.isHidden = false
    }

    func configure(
        day: Int,
        isPeriod: Bool = false,
        isPredicted: Bool = false,
        isFertile: Bool = false
    ) {
        // If day is 0, it's an offset cell
        if day == 0 {
            dayLabel.text = ""
            selectionCircleView.backgroundColor = .clear
            return
        }

        dayLabel.text = "\(day)"
        dayLabel.font = .systemFont(ofSize: 18, weight: .regular)

        if isPeriod {
            // Native style: Small solid pink/red circle
            selectionCircleView.backgroundColor = .systemPink
            selectionCircleView.layer.borderWidth = 0
            dayLabel.textColor = .white
        }
        else if isPredicted {
            // Native style: Pink border or light pink fill
            selectionCircleView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.15)
            selectionCircleView.layer.borderWidth = 1
            selectionCircleView.layer.borderColor = UIColor.systemPink.cgColor
            dayLabel.textColor = .systemPink
        }
        else if isFertile {
            selectionCircleView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            selectionCircleView.layer.borderWidth = 0
            dayLabel.textColor = .label
        }
        else {
            // Normal day: No background, just the number
            selectionCircleView.backgroundColor = .clear
            selectionCircleView.layer.borderWidth = 0
            dayLabel.textColor = .label
        }
    }
}
