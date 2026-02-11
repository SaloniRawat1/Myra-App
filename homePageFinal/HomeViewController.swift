//
//  ViewController.swift
//  homePageFinal
//
//  Created by GEU on 06/02/26.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var ringView: UIView!
    @IBOutlet weak var nextDateLabel: UILabel!
    @IBOutlet weak var currentCycleLabel: UILabel!
    @IBOutlet weak var PreviousCycleLabel: UILabel!
    @IBOutlet weak var cycleCardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawActivityRings()
        updateCycleCard()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCycleCard()
    }


    
    func updateCycleCard() {

        let data = PeriodData.shared

        // Next predicted date
        if let next = data.nextPredictedDate() {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            nextDateLabel.text = formatter.string(from: next)
        } else {
            nextDateLabel.text = "--"
        }

        // Current cycle length
        if let current = data.currentCycleLength() {
            currentCycleLabel.text = "\(current) days"
        } else {
            currentCycleLabel.text = "--"
        }

        // Previous cycle
        PreviousCycleLabel.text = "\(data.previousCycleLength()) days"
        
        let phase = PeriodData.shared.getCyclePhase()
            cycleCardLabel.text = phase
    }

    
    func drawActivityRings() {

            let center = CGPoint(x: ringView.bounds.width / 2,
                                 y: ringView.bounds.height / 2)

            // Calories Ring (Outer)
            createRing(
                radius: 30,
                lineWidth: 6,
                progress: 0.7,   // 70%
                color: UIColor.systemPink,
                center: center
            )

            // Water Ring (Middle)
            createRing(
                radius: 20,
                lineWidth: 6,
                progress: 0.8,
                color: UIColor.systemTeal,
                center: center
            )

            // Steps Ring (Inner)
            createRing(
                radius: 10,
                lineWidth: 6,
                progress: 0.6,
                color: UIColor.systemGreen,
                center: center
            )
        }

        func createRing(radius: CGFloat,
                        lineWidth: CGFloat,
                        progress: CGFloat,
                        color: UIColor,
                        center: CGPoint) {

            let circularPath = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: -CGFloat.pi / 2,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            )

            // Background ring
            let bgLayer = CAShapeLayer()
            bgLayer.path = circularPath.cgPath
            bgLayer.strokeColor = UIColor.systemGray5.cgColor
            bgLayer.lineWidth = lineWidth
            bgLayer.fillColor = UIColor.clear.cgColor
            ringView.layer.addSublayer(bgLayer)

            // Progress ring
            let progressLayer = CAShapeLayer()
            progressLayer.path = circularPath.cgPath
            progressLayer.strokeColor = color.cgColor
            progressLayer.lineWidth = lineWidth
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeEnd = progress
            progressLayer.lineCap = .round

            // Animation
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 1.2
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            progressLayer.add(animation, forKey: "progressAnim")

            ringView.layer.addSublayer(progressLayer)
        }
}

