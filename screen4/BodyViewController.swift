//
//  BodyViewController.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

class BodyViewController: UIViewController, YogaCellDelegate {
    func didTapStartButton() {
        performSegue(withIdentifier: "showPoseDetail", sender: nil)
    }

    
    @IBOutlet weak var bodyCollectionView: UICollectionView!
    
    let fitnessData = FitnessData()
    var yogaFitness: [Fitness] = []
    var exerciseFitness: [Fitness] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        yogaFitness = fitnessData.fitness(for: .yoga)
        exerciseFitness = fitnessData.fitness(for: .exercise)
        
        registerCells()
        bodyCollectionView.dataSource = self
        bodyCollectionView.collectionViewLayout = generateLayout()
        // Do any additional setup after loading the view.
    }
    
    
    func registerCells(){
        bodyCollectionView.register(UINib(nibName: "yogaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "yoga_cell")
        
        bodyCollectionView.register(UINib(nibName: "exceriseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "exercise_cell")
    }
    
    func generateLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            sectionIndex == 0 ? self.yogaSection() : self.exerciseSection()
        }
    }
    
    func yogaSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .fractionalWidth(1),
                      heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(0.9),
                              heightDimension: .absolute(220)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 10, leading: 16, bottom: 10, trailing: 16)
        return section
    }
    
    func exerciseSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .fractionalWidth(1),
                      heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .absolute(220)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 10, leading: 16, bottom: 10, trailing: 16)
        return section
    }
}

extension BodyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        section == 0 ? yogaFitness.count : exerciseFitness.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "yoga_cell", for: indexPath
            ) as! yogaCollectionViewCell
            cell.configureCell(yoga: yogaFitness[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "exercise_cell", for: indexPath
        ) as! exceriseCollectionViewCell
        cell.configureCell(excercise: exerciseFitness[indexPath.row])
        return cell
    }
}
