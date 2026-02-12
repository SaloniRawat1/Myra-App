//
//  MindViewController.swift
//  screen4
//
//  Created by GEU on 07/02/26.
//

import UIKit

class MindViewController: UIViewController {

    @IBOutlet weak var mindCollectionView: UICollectionView!
    var mindData = MindTherapyData()

        var meditationMind: [Mind] = []
        var musicTherapyMind: [Mind] = []

        override func viewDidLoad() {
            super.viewDidLoad()

            meditationMind = mindData.mind(for: .meditation)
            musicTherapyMind = mindData.mind(for: .musicTherapy)

            registerCells()

            mindCollectionView.dataSource = self
            mindCollectionView.collectionViewLayout = generateLayout()
        }

        func registerCells() {

            mindCollectionView.register(
                UINib(nibName: "MeditationCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "meditation_cell"
            )

            mindCollectionView.register(
                UINib(nibName: "MusicTherapyCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "music_cell"
            )
        }

        func generateLayout() -> UICollectionViewLayout
    {
        UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            sectionIndex == 0 ? self.generateSectionForMusicTherapy() : self.generateSectionForMeditation()
        }
        
    }

        // MARK: - Section 0 (Music Therapy - Horizontal)

    func generateSectionForMusicTherapy() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(150)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 10

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )

        // horizontal scrolling
        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    // MARK: - Section 1 (Meditation - Vertical)

    func generateSectionForMeditation() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(220)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 10

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )

        // ⚠️ no orthogonalScrollingBehavior here
        // so this section scrolls vertically with the collection view

        return section
    }
    }

    extension MindViewController: UICollectionViewDataSource {

        func numberOfSections(in collectionView: UICollectionView) -> Int {return 2}

        func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {

            if section == 0 {
                // music
                return musicTherapyMind.count
            }
            else {
                // meditation
                return meditationMind.count
            }
        }

        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            if indexPath.section == 0 {

                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "music_cell",
                    for: indexPath
                ) as! MusicTherapyCollectionViewCell
                cell.configureCell(musicTherapy: musicTherapyMind[indexPath.row])
                return cell
            }

                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "meditation_cell",
                    for: indexPath
                ) as! MeditationCollectionViewCell

            cell.configureCell(meditation: meditationMind[indexPath.row])
                return cell
        }
    }
