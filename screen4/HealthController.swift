//
//  ViewController.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

class HealthController: UIViewController {
    
    
    @IBOutlet weak var mindContainerView: UIView!
    @IBOutlet weak var bodyContainerView: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyContainerView.isHidden = false
        mindContainerView.isHidden = true
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        bodyContainerView.isHidden = sender.selectedSegmentIndex != 0
        mindContainerView.isHidden = sender.selectedSegmentIndex == 0
    }
}
