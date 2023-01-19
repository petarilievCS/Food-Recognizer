//
//  ResponseObject.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 19.1.23.
//

import Foundation

struct ResponseObject: Encodable {
    let foods: [Food]
}

struct Food: Encodable {
    let foodNutrients: [Nutrient]
}

struct Nutrient: Encodable {
    let nutrientId: Int
    let value: Int
}

// Nutrient IDs
// Energy - 1008
// Protein - 1003
// Carbs - 1050
// Fat - 1004
