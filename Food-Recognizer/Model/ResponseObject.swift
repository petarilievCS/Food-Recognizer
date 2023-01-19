//
//  ResponseObject.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 19.1.23.
//

import Foundation

struct ResponseObject: Codable {
    let foods: [Food]
}

struct Food: Codable {
    let foodNutrients: [Nutrient]
}

struct Nutrient: Codable {
    let nutrientId: Int
    let value: Int
}


