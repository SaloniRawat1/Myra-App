import UIKit

class TrackViewController: UIViewController {

    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthCollectionView: UICollectionView!

    let monthsData: [MonthModel] = [
        MonthModel(name: "January",   days: 31, index: 0),
        MonthModel(name: "February",  days: 28, index: 1),
        MonthModel(name: "March",     days: 31, index: 2),
        MonthModel(name: "April",     days: 30, index: 3),
        MonthModel(name: "May",       days: 31, index: 4),
        MonthModel(name: "June",      days: 30, index: 5),
        MonthModel(name: "July",      days: 31, index: 6),
        MonthModel(name: "August",    days: 31, index: 7),
        MonthModel(name: "September", days: 30, index: 8),
        MonthModel(name: "October",   days: 31, index: 9),
        MonthModel(name: "November",  days: 30, index: 10),
        MonthModel(name: "December",  days: 31, index: 11)
    ]

    let calendar = Calendar.current

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(monthCollectionView)

        // Scroll to current month
        let currentMonth = calendar.component(.month, from: Date()) - 1
        if currentMonth < monthsData.count {
            DispatchQueue.main.async {
                self.monthCollectionView.scrollToItem(
                    at: IndexPath(item: 0, section: currentMonth),
                    at: .top,
                    animated: false
                )
            }
        }
    }

    private func setupCollectionView(_ cv: UICollectionView) {
        cv.dataSource = self
        cv.delegate = self

        if let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        }
    }

    // MARK: - Logic Helpers
    func getOffset(for section: Int) -> Int {
        let month = monthsData[section]
        var components = DateComponents()
        components.year = 2026
        components.month = month.index + 1
        components.day = 1

        if let firstDay = calendar.date(from: components) {
            return calendar.component(.weekday, from: firstDay) - 1
        }
        return 0
    }

    func isPredictedPeriodDay(_ date: Date) -> Bool {
        guard let last = PeriodData.shared.lastPeriodStart else { return false }
        for cycle in 1...12 {
            guard let cycleStart = calendar.date(byAdding: .day, value: 28 * cycle, to: last) else { continue }
            for i in 0..<5 {
                if let predictedDay = calendar.date(byAdding: .day, value: i, to: cycleStart),
                   calendar.isDate(predictedDay, inSameDayAs: date) { return true }
            }
        }
        return false
    }

    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionView Delegate & DataSource
extension TrackViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return monthsData.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthsData[section].days + getOffset(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCell

        let offset = getOffset(for: indexPath.section)

        if indexPath.item < offset {
            cell.isHidden = true
            return cell
        }

        cell.isHidden = false
        let day = indexPath.item - offset + 1
        let month = monthsData[indexPath.section]

        var components = DateComponents()
        components.year = 2026
        components.month = month.index + 1
        components.day = day

        if let date = calendar.date(from: components) {
            setupSmallCircleConstraints(for: cell)
            cell.configure(
                day: day,
                isPeriod: PeriodData.shared.isPeriodDay(date),
                isPredicted: isPredictedPeriodDay(date),
                isFertile: PeriodData.shared.isFertileDay(date)
            )
        }
        return cell
    }

    private func setupSmallCircleConstraints(for cell: MonthCell) {
        let circle = cell.selectionCircleView!
        circle.translatesAutoresizingMaskIntoConstraints = false

        circle.constraints.forEach { constraint in
            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                circle.removeConstraint(constraint)
            }
        }

        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: 35),
            circle.heightAnchor.constraint(equalToConstant: 35)
        ])

        circle.layer.cornerRadius = 35 / 2
        circle.layer.masksToBounds = true
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }

    // MARK: - Layout Sizing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = floor(collectionView.frame.width / 7)
        return CGSize(width: itemWidth, height: itemWidth * 1.05)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 0 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 0 }

    // MARK: - Section Headers
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthHeaderView", for: indexPath) as! MonthHeaderView
        header.titleLabel.text = monthsData[indexPath.section].name
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 44)
    }

    // MARK: - Tap to Log/Remove
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let offset = getOffset(for: indexPath.section)
        if indexPath.item < offset { return }

        let day = indexPath.item - offset + 1
        let month = monthsData[indexPath.section]

        var components = DateComponents()
        components.year = 2026
        components.month = month.index + 1
        components.day = day

        if let date = calendar.date(from: components) {
            let isAlreadyPeriod = PeriodData.shared.isPeriodDay(date)
            let alert = UIAlertController(
                title: isAlreadyPeriod ? "Remove Period" : "Log Period",
                message: nil,
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: isAlreadyPeriod ? "Remove" : "Log",
                                          style: isAlreadyPeriod ? .destructive : .default) { _ in
                PeriodData.shared.togglePeriod(on: date)
                self.monthCollectionView.reloadData()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }
}
