import UIKit
import AVKit

class PoseDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poseImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var dosLabel: UILabel!
    @IBOutlet weak var dontsLabel: UILabel!
    @IBOutlet weak var videoContainerView: UIView!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var timeObserverToken: Any?


    override func viewDidLoad() {
        super.viewDidLoad()
        //setupUI()
    }
//    func setupUI() {
//        titleLabel.text = "Butterfly Pose"
//        poseImageView.image = UIImage(named: "ButterflyPose")
//
////        timerLabel.text = "0:00 / 8:00"
////        progressView.progress = 0.0
//
//        dosLabel.text = """
//        • Sit with spine straight
//        • Keep soles of feet together
//        • Gently press knees towards floor
//        • Breathe deeply to hold
//        """
//
//        dontsLabel.text = """
//        • Don't force knees
//        • Avoid if knee injury
//        • Don't round your back
//        • Skip if severe pain
//        """
//    }
    @IBAction func playTapped(_ sender: UIButton) {
        
        guard let path = Bundle.main.path(
            forResource: "ButterFly",
            ofType: "mp4"
        ) else {
            print("Video not found")
            return
        }

        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.videoGravity = .resizeAspect

        if let layer = playerLayer {
            videoContainerView.layer.addSublayer(layer)
        }

        poseImageView.isHidden = true
        playButton.isHidden = true
        videoContainerView.isHidden = false

        player?.play()
        observeVideoProgress()
    }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           playerLayer?.frame = videoContainerView.bounds
       }
    @IBAction func closeTapped(_ sender: UIButton) {
        player?.pause()
        dismiss(animated: true)
    }
    
    func observeVideoProgress() {
        guard let player = player else { return }

        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            guard let self = self else { return }

            let currentSeconds = CMTimeGetSeconds(time)
            guard let duration = player.currentItem?.duration else { return }
            let totalSeconds = CMTimeGetSeconds(duration)

            if totalSeconds.isNaN || totalSeconds == 0 { return }

            // Update timer label
            let currentText = self.formatTime(currentSeconds)
            let totalText = self.formatTime(totalSeconds)
            self.timerLabel.text = "\(currentText) / \(totalText)"

            // Update progress bar
            self.progressView.progress = Float(currentSeconds / totalSeconds)
        }
    }
    func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }

    deinit {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
        }
    }


}
