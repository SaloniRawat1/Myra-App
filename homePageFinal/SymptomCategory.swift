//
//  SymptomCategory.swift
//  SymptomsPage3
//
//  Created by GEU on 11/02/26.
//


import Foundation

struct SymptomCategory {
    let title: String
    var isExpanded: Bool
    var symptoms: [Symptom]
}

struct Symptom {
    let name: String
    var isSelected: Bool
}

