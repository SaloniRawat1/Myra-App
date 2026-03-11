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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCycleCard()
    }

    func updateCycleCard() {

        let data = PeriodData.shared

        // MARK: Next predicted date
        if let next = data.nextPredictedDate() {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            nextDateLabel.text = formatter.string(from: next)
        } else {
            nextDateLabel.text = "--"
        }

        // MARK: Current cycle length
        let current = data.currentCycleLength()
        if current > 0 {
            currentCycleLabel.text = "\(current) days"
        } else {
            currentCycleLabel.text = "--"
        }

        // MARK: Previous cycle length
        let previous = data.previousCycleLength()
        if previous > 0 {
            PreviousCycleLabel.text = "\(previous) days"
        } else {
            PreviousCycleLabel.text = "--"
        }

        // MARK: Cycle phase
        let phase = data.getCyclePhase()
        cycleCardLabel.text = phase
    }

    func openHealthScreen() {
        let storyboard = UIStoryboard(name: "Fitness", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HealthController") as! HealthViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func drawActivityRings() {

        let center = CGPoint(
            x: ringView.bounds.width / 2,
            y: ringView.bounds.height / 2
        )

        createRing(
            radius: 30,
            lineWidth: 6,
            progress: 0.7,
            color: UIColor.systemPink,
            center: center
        )

        createRing(
            radius: 20,
            lineWidth: 6,
            progress: 0.8,
            color: UIColor.systemTeal,
            center: center
        )

        createRing(
            radius: 10,
            lineWidth: 6,
            progress: 0.6,
            color: UIColor.systemGreen,
            center: center
        )
    }

    func createRing(
        radius: CGFloat,
        lineWidth: CGFloat,
        progress: CGFloat,
        color: UIColor,
        center: CGPoint
    ) {

        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )

        let bgLayer = CAShapeLayer()
        bgLayer.path = circularPath.cgPath
        bgLayer.strokeColor = UIColor.systemGray5.cgColor
        bgLayer.lineWidth = lineWidth
        bgLayer.fillColor = UIColor.clear.cgColor
        ringView.layer.addSublayer(bgLayer)

        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = color.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = progress
        progressLayer.lineCap = .round

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        progressLayer.add(animation, forKey: "progressAnim")

        ringView.layer.addSublayer(progressLayer)
    }
}
