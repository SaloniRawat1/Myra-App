//
//  ViewController.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

class HealthViewController: UIViewController {
    
    
//    @IBOutlet weak var mindContainerView: UIView?
//  @IBOutlet weak var bodyContainerView: UIView?
//    
//    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    @IBOutlet weak var mindContainerView: UIView!
    @IBOutlet weak var bodyContainerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Health Loaded")
        setupUI() 
        
        updateViewVisibility(index: 0)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateViewVisibility(index: sender.selectedSegmentIndex)
    }
    func setupUI(){
        segmentControl.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        segmentControl.selectedSegmentTintColor = .white
        segmentControl.setTitle("Body", forSegmentAt: 0)
        segmentControl.setTitle("Mind", forSegmentAt: 1)
        
        
    }
    func updateViewVisibility(index :Int){
        mindContainerView.isHidden = true
        bodyContainerView.isHidden = true
        
        switch index {
        case 0:
            bodyContainerView.isHidden = false
        case 1:
            mindContainerView.isHidden = false
        default:
            break
        }
    }
}





//   func openHealthScreen() {
//
//        let storyboard = UIStoryboard(name: "Fitness", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HealthController") as! HealthController
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
