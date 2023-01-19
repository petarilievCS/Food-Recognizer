//
//  APIManager.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 17.1.23.
//

import Foundation

struct APIManager {
    
    let URLString = "https://api.nal.usda.gov/fdc/v1/search"
    
    // Performs API request to FoodData Central for given food
    func performRequest(for food: String) {
        
        if let URL = URL(string: "\(URLString)?api_key=\(Keys.foodDataCentralAPIKey)&query=\(food)&pageSize=1&pageNumber=1&dataType=Foundation") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: URL) { data, response, error in
                if error != nil {
                    print("Error: API request failed")
                }
                
                if let safeData = data {
                    print(String(data: safeData, encoding: .utf8))
                }
            }
            task.resume()
        }
        
    }
    
}


