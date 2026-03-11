import UIKit
import Charts
import DGCharts

class SummaryViewController: UIViewController {

    @IBOutlet weak var cycleChartView: LineChartView!
    @IBOutlet weak var weightChartView: LineChartView!

    @IBOutlet weak var stabilityLabel: UILabel!
    @IBOutlet weak var analysisLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCycleChart()

        let result = analyzeCycleIrregularity()

        stabilityLabel.text = "Cycle Stability: \(result.stability)%"
        analysisLabel.text = result.message

        if result.stability > 75 {
            stabilityLabel.textColor = .systemGreen
        }
        else if result.stability > 50 {
            stabilityLabel.textColor = .systemOrange
        }
        else {
            stabilityLabel.textColor = .systemRed
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupCycleChart()
    }

    // MARK: Cycle Length Calculation

    func calculateCycleLengths() -> [Double] {

        let starts = PeriodData.shared.periodStarts

        if starts.count < 2 { return [] }

        var cycles: [Double] = []

        for i in 1..<starts.count {

            let diff = Calendar.current.dateComponents(
                [.day],
                from: starts[i-1],
                to: starts[i]
            ).day ?? 0

            cycles.append(Double(diff))
        }

        print("Detected cycles:", cycles)

        return cycles
    }

    // MARK: Cycle Chart

    func setupCycleChart() {

        let cycleLengths = calculateCycleLengths()

        if cycleLengths.isEmpty {

            cycleChartView.clear()
            cycleChartView.noDataText = "Log at least 2 cycles to see insights"

            return
        }

        var entries: [ChartDataEntry] = []

        for (index,value) in cycleLengths.enumerated() {
            entries.append(ChartDataEntry(x: Double(index + 1), y: value))
        }

        let dataSet = LineChartDataSet(entries: entries, label: "Cycle Length (Days)")

        dataSet.colors = [.systemPink]
        dataSet.circleColors = [.systemPink]
        dataSet.circleRadius = 4
        dataSet.lineWidth = 2
        dataSet.mode = .cubicBezier
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = .systemPink.withAlphaComponent(0.3)

        let data = LineChartData(dataSet: dataSet)

        cycleChartView.data = data

        cycleChartView.xAxis.labelPosition = .bottom
        cycleChartView.xAxis.granularity = 1

        cycleChartView.leftAxis.axisMinimum = 20
        cycleChartView.leftAxis.axisMaximum = 60
        cycleChartView.rightAxis.enabled = false

        cycleChartView.doubleTapToZoomEnabled = false
        cycleChartView.chartDescription.enabled = false

        cycleChartView.animate(xAxisDuration: 1.0)

        let limitLine = ChartLimitLine(limit: 32, label: "Normal Upper Limit")

        limitLine.lineColor = .systemGreen
        limitLine.lineDashLengths = [5,5]

        cycleChartView.leftAxis.removeAllLimitLines()
        cycleChartView.leftAxis.addLimitLine(limitLine)
    }

    // MARK: Cycle Irregularity Analysis

    func analyzeCycleIrregularity() -> (stability: Int, message: String) {

        let cycles = calculateCycleLengths()

        if cycles.count < 2 {
            return (0, "Log more cycles to analyze pattern")
        }

        let avg = cycles.reduce(0,+) / Double(cycles.count)

        var totalDeviation: Double = 0

        for cycle in cycles {
            totalDeviation += abs(cycle - avg)
        }

        let avgDeviation = totalDeviation / Double(cycles.count)

        let stabilityScore = max(0, 100 - Int(avgDeviation * 3))

        var message = ""

        if avg > 35 {
            message = "Long cycles detected. Possible PCOS pattern"
        }
        else if avg < 21 {
            message = "Short cycles detected"
        }
        else if avgDeviation > 7 {
            message = "Irregular cycles detected"
        }
        else {
            message = "Cycle looks stable"
        }

        return (stabilityScore, message)
    }
}
