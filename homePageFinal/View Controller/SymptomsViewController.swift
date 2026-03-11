//
//  ViewController.swift
//  SymptomsPage3
//
//  Created by GEU on 11/02/26.
//

import UIKit

class SymptomsViewController: UIViewController, UICollectionViewDelegate,
                      UICollectionViewDataSource,
                      UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!

    var categories: [SymptomCategory] = [
        SymptomCategory(title: "Skin & Hair", isExpanded: false, symptoms: [
            Symptom(name: "Acne", isSelected: false),
            Symptom(name: "Dry Skin", isSelected: false),
            Symptom(name: "Excess Hair Growth", isSelected: false),
            Symptom(name: "Oily Skin", isSelected: false),
            Symptom(name: "Hair Thinning", isSelected: false)
        ]),
        
        SymptomCategory(title: "Menstrual", isExpanded: false, symptoms: [
            Symptom(name: "Light Flow", isSelected: false),
            Symptom(name: "Cramping", isSelected: false),
            Symptom(name: "Heavy Flow", isSelected: false),
            Symptom(name: "Irregular Periods", isSelected: false),
            Symptom(name: "Spotting", isSelected: false),
            Symptom(name: "Missed Period", isSelected: false)
        ]),
        
        SymptomCategory(title: "Emotional", isExpanded: false, symptoms: [
            Symptom(name: "Anxiety", isSelected: false),
            Symptom(name: "Mood Swings", isSelected: false),
            Symptom(name: "Depression", isSelected: false),
            Symptom(name: "Brain Fog", isSelected: false),
            Symptom(name: "Irritability", isSelected: false),
            Symptom(name: "Sleep Issues", isSelected: false)
        ]),
        
        SymptomCategory(title: "Physical", isExpanded: false, symptoms: [
            Symptom(name: "Fatigue", isSelected: false),
            Symptom(name: "Headache", isSelected: false),
            Symptom(name: "Weight Gain", isSelected: false),
            Symptom(name: "Tender Breast", isSelected: false),
            Symptom(name: "Bloating", isSelected: false),
            Symptom(name: "Body Ache", isSelected: false)
        ]),
        
        SymptomCategory(title: "Metabolic", isExpanded: false, symptoms: [
            Symptom(name: "Low Energy", isSelected: false),
            Symptom(name: "Sugar Cravings", isSelected: false),
            Symptom(name: "Thirst", isSelected: false),
            Symptom(name: "Frequent Urination", isSelected: false),
            Symptom(name: "Increased Appetite", isSelected: false)
        ]),
        
        SymptomCategory(title: "Digestive", isExpanded: false, symptoms: [
            Symptom(name: "Bloating", isSelected: false),
            Symptom(name: "Constipation", isSelected: false),
            Symptom(name: "Gas", isSelected: false),
            Symptom(name: "Diarrhea", isSelected: false),
            Symptom(name: "Stomach Pain", isSelected: false),
            Symptom(name: "Nausea", isSelected: false)
        ])
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateSaveButton()


    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categories[section].isExpanded ? categories[section].symptoms.count : 0
    }



    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SymptomCell",
            for: indexPath) as! SymptomCell

        let symptom = categories[indexPath.section].symptoms[indexPath.row]
        cell.configure(with: symptom)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 120, height: 36)
    }


    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "CategoryHeaderView",
            for: indexPath) as! CategoryHeaderView

        let category = categories[indexPath.section]
        header.configure(title: category.title, isExpanded: category.isExpanded)

        header.tapAction = { [weak self] in
            guard let self = self else { return }
            self.categories[indexPath.section].isExpanded.toggle()
            self.collectionView.reloadSections(IndexSet(integer: indexPath.section))
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        categories[indexPath.section]
            .symptoms[indexPath.row]
            .isSelected.toggle()

        collectionView.reloadItems(at: [indexPath])

        updateSaveButton()
    }

    func updateSaveButton() {
        let count = categories
            .flatMap { $0.symptoms }
            .filter { $0.isSelected }
            .count
        
        saveButton.setTitle("Save (\(count) selected)", for: .normal)
    }

   

}

