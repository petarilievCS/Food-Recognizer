//
//  APIManager.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 17.1.23.
//

import Foundation

protocol APIManagerDelegate {
    func didUpdateInformation(foodModel: FoodModel)
    func didNotDetectFood()
}

struct APIManager {
    
    let URLString = "https://api.nal.usda.gov/fdc/v1/search"
    var delegate: APIManagerDelegate?
    
    // Performs API request to FoodData Central for given food
    func performRequest(for food: String) {
        
        let foodWithNoSpaces = food.replacing(" ", with: "%20")
        if let URL = URL(string: "\(URLString)?api_key=\(Keys.foodDataCentralAPIKey)&query=\(foodWithNoSpaces)&pageSize=1&pageNumber=1&dataType=Survey%20(FNDDS)") {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: URL) { data, response, error in
                if error != nil {
                    print("Error: API request failed")
                }
                
                if let safeData = data {
                    if let foodModel = parseJSON(from: safeData, for: food) {
                        delegate?.didUpdateInformation(foodModel: foodModel)
                    } else {
                        delegate?.didNotDetectFood()
                        print("Error: Data not parsed")
                    }
                } else {
                    print("Error: No API response")
                }
            }
            task.resume()
        } else {
            print("Error: URL couldn't be formed")
        }
        
    }
    
    // Parse the API response from FoodData Central
    func parseJSON(from foodData: Data, for foodName: String) -> FoodModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ResponseObject.self, from: foodData)
            let calories = nutrientValue(for: K.caloriesID, in: decodedData)
            let protein = nutrientValue(for: K.proteinID, in: decodedData)
            let carbs = nutrientValue(for: K.carbsID, in: decodedData)
            let fats = nutrientValue(for: K.fatsID, in: decodedData)
            let foodModel = FoodModel(name: foodName, calories: calories, protein: protein, fats: fats, carbs: carbs)
            
            // No response from API
            if calories == -1 {
                return nil
            }
            
            return foodModel
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    // Returns the value of the nutrient with the given ID, -1 if nutrient not found
    func nutrientValue(for ID: Int, in responseObject: ResponseObject) -> Double {
        if responseObject.foods.count >= 1 {
            for nutrient in responseObject.foods[0].foodNutrients {
                if nutrient.nutrientId == ID {
                    return nutrient.value
                }
            }
        }
        return -1
    }
}


