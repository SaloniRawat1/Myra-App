//
//  ViewController.swift
//  TrackPage
//

import UIKit

class TrackViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var yearCollectionView: UICollectionView!
    @IBOutlet weak var monthCollectionView: UICollectionView!

    // MARK: - Back Button
    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Data
    let months = ["Jan","Feb","Mar","Apr","May","Jun",
                  "Jul","Aug","Sep","Oct","Nov","Dec"]

    let monthsData: [MonthModel] = [
        MonthModel(name: "January", days: 31, index: 0),
        MonthModel(name: "February", days: 28, index: 1),
        MonthModel(name: "March", days: 31, index: 2)
    ]

    var selectedMonthIndex: Int = 0
    var displayedMonthIndex: Int = 0

    // ✅ USER LOGGED PERIOD STORAGE
    // [monthIndex : set of days]
    var loggedPeriods: [Int: Set<Int>] = [:]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        yearCollectionView.dataSource = self
        yearCollectionView.delegate = self

        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self

        // load saved periods
        loadPeriods()

        // default screen → Month first
        segmentControl.selectedSegmentIndex = 0
        updateUI(for: 0)
    }
    func isPredictedPeriodDay(_ date: Date) -> Bool {

        guard let last = PeriodData.shared.lastPeriodStart else {
            return false
        }

        let calendar = Calendar.current

        // next cycle start (28 days after last period)
        guard let nextStart = calendar.date(byAdding: .day, value: 28, to: last) else {
            return false
        }

        // predicted 5 days period
        for i in 0..<5 {
            if let predictedDay = calendar.date(byAdding: .day, value: i, to: nextStart),
               calendar.isDate(predictedDay, inSameDayAs: date) {
                return true
            }
        }

        return false
    }

    
    
    
    // MARK: - Segmented Control
    @IBAction func segementChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.25) {
            self.updateUI(for: sender.selectedSegmentIndex)
        }
    }

    func updateUI(for index: Int) {
        monthView.isHidden = index != 0
        yearView.isHidden = index == 0
    }

    // MARK: - SAVE / LOAD DATA
    func savePeriods() {

        // convert [Int:Set<Int>] → [String:[Int]]
        var dict: [String: [Int]] = [:]

        for (key, value) in loggedPeriods {
            dict[String(key)] = Array(value)
        }

        UserDefaults.standard.set(dict, forKey: "loggedPeriods")
    }


    func loadPeriods() {
        if let saved = UserDefaults.standard.dictionary(forKey: "loggedPeriods") as? [Int: [Int]] {
            loggedPeriods = saved.mapValues { Set($0) }
        }
    }
}

// MARK: - Collection View
extension TrackViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if collectionView == yearCollectionView {
            return months.count
        }

        if collectionView == monthCollectionView {
            return monthsData[section].days
        }

        return 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == monthCollectionView {
            return monthsData.count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // YEAR VIEW → MONTH GRID
        if collectionView == yearCollectionView {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "YearMonthCell",
                for: indexPath
            ) as! YearMonthCell

            cell.monthLabel.text = months[indexPath.item]
            let isSelected = indexPath.item == selectedMonthIndex
            cell.configure(isSelected: isSelected)

            return cell
        }

        // MONTH VIEW → CALENDAR DAYS
        else {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MonthCell",
                for: indexPath
            ) as! MonthCell

            let month = monthsData[indexPath.section]
            let day = indexPath.item + 1

            // create actual date (2026 + selected month + day)
            var components = DateComponents()
            components.year = Calendar.current.component(.year, from: Date())
            components.month = month.index + 1
            components.day = day

            let date = Calendar.current.date(from: components)!

            // check period & fertile
            let isPeriod = PeriodData.shared.isPeriodDay(date)
            let isFertile = PeriodData.shared.isFertileDay(date)
            let isPredicted = isPredictedPeriodDay(date)

            cell.configure(
                day: day,
                isPeriod: isPeriod,
                isPredicted: isPredicted,
                isFertile: isFertile
            )

            return cell
        }
    }

    // MARK: - Selection (MAIN LOGIC)
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        if collectionView == monthCollectionView {

            let month = monthsData[indexPath.section]
            let day = indexPath.item + 1

            // convert to Date
            var components = DateComponents()
            components.year = Calendar.current.component(.year, from: Date())
            components.month = month.index + 1
            components.day = day

            let date = Calendar.current.date(from: components)!

            let alert = UIAlertController(
                title: "Log Period",
                message: "Mark this day?",
                preferredStyle: .actionSheet
            )

            alert.addAction(UIAlertAction(title: "Start Period", style: .default) { _ in
                PeriodData.shared.togglePeriod(on: date)
                self.monthCollectionView.reloadData()
            })

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true)
        }
    }



    // MARK: - Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == yearCollectionView {
            let width = (collectionView.frame.width - 48) / 2
            return CGSize(width: width, height: 56)
        }

        let width = collectionView.frame.width / 7 - 6
        return CGSize(width: width, height: width)
    }

    // MARK: - Header
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard collectionView == monthCollectionView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "MonthHeaderView",
            for: indexPath
        ) as! MonthHeaderView

        header.titleLabel.text = monthsData[indexPath.section].name
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        return collectionView == monthCollectionView
        ? CGSize(width: collectionView.frame.width, height: 44)
        : .zero
    }
}
