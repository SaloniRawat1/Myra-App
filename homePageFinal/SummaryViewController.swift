//
//  SummarViewController.swift
//  homePageFinal
//
//  Created by GEU on 07/02/26.
//

import UIKit
import Charts
import DGCharts

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var cycleChartView: LineChartView!
    @IBOutlet weak var weightChartView: LineChartView!

        override func viewDidLoad() {
            super.viewDidLoad()
            setupCycleChart()
            setupWeightChart()
        }

        func setupCycleChart() {

            // Sample cycle data (cycle length in days)
            let cycleLengths: [Double] = [45, 38, 32, 35, 30, 28]

            var entries: [ChartDataEntry] = []

            for (index, value) in cycleLengths.enumerated() {
                entries.append(ChartDataEntry(x: Double(index), y: value))
            }

            let dataSet = LineChartDataSet(entries: entries, label: "Cycle Length (Days)")

            // 🎨 Styling
            dataSet.colors = [.systemPink]
            dataSet.circleColors = [.systemPink]
            dataSet.circleRadius = 4
            dataSet.lineWidth = 2
            dataSet.valueFont = .systemFont(ofSize: 10)
            dataSet.mode = .cubicBezier
            dataSet.drawFilledEnabled = true
            dataSet.fillColor = .systemPink.withAlphaComponent(0.3)

            let data = LineChartData(dataSet: dataSet)
            cycleChartView.data = data

            // X-Axis labels
            cycleChartView.xAxis.valueFormatter = IndexAxisValueFormatter(
                values: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
            )
            cycleChartView.xAxis.granularity = 1
            cycleChartView.xAxis.labelPosition = .bottom

            // Y-Axis
            cycleChartView.leftAxis.axisMinimum = 20
            cycleChartView.leftAxis.axisMaximum = 50
            cycleChartView.rightAxis.enabled = false

            // Disable zoom & description
            cycleChartView.doubleTapToZoomEnabled = false
            cycleChartView.chartDescription.enabled = false

            // Animation
            cycleChartView.animate(xAxisDuration: 1.0)
            
                let limitLine = ChartLimitLine(limit: 32, label: "Normal Upper Limit")
                limitLine.lineColor = .systemGreen
                limitLine.lineDashLengths = [5, 5]
                limitLine.labelPosition = .rightTop
                cycleChartView.leftAxis.addLimitLine(limitLine)
            
            
        }
     

    func setupWeightChart() {

        let monthlyWeights: [Double] = [68, 67.5, 66.8, 66.2, 65.7, 65.0]

        var entries: [ChartDataEntry] = []

        for (index, weight) in monthlyWeights.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: weight))
        }

        let dataSet = LineChartDataSet(entries: entries, label: "Weight (kg)")
        
        // 🎨 Styling
        dataSet.colors = [.systemPurple]
        dataSet.circleColors = [.systemPurple]
        dataSet.circleRadius = 3
        dataSet.lineWidth = 2
        dataSet.mode = .cubicBezier
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = .systemPurple.withAlphaComponent(0.25)
        dataSet.valueFont = .systemFont(ofSize: 9)

        let data = LineChartData(dataSet: dataSet)
        weightChartView.data = data

        // X-Axis
        weightChartView.xAxis.valueFormatter = IndexAxisValueFormatter(
            values: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        )
        weightChartView.xAxis.granularity = 1
        weightChartView.xAxis.labelPosition = .bottom

        // Y-Axis
        weightChartView.leftAxis.axisMinimum = 60
        weightChartView.leftAxis.axisMaximum = 75
        weightChartView.rightAxis.enabled = false

        // Clean look
        weightChartView.doubleTapToZoomEnabled = false
        weightChartView.chartDescription.enabled = false

        weightChartView.animate(xAxisDuration: 1.0)
    }

}
