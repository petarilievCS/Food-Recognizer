//
//  FoodViewController.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 16.1.23.
//

import UIKit

class FoodViewController: UIViewController {
    
    let cornerRadiusConstant: CGFloat = 10
    var image: UIImage?
    var foodModel: FoodModel?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var proteinView: UIView!
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var fatsView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        caloriesView.layer.cornerRadius = cornerRadiusConstant
        proteinView.layer.cornerRadius = cornerRadiusConstant
        carbsView.layer.cornerRadius = cornerRadiusConstant
        fatsView.layer.cornerRadius = cornerRadiusConstant
        
        // Set image if present
        if let safeImage = image {
            imageView.image = safeImage
        }
        
    }
}

extension FoodViewController: HomeViewControllerDelegate {
    
    func didNotDetectFood() {
        DispatchQueue.main.async {
            self.nameLabel?.text = "Did not detect food"
            self.caloriesLabel?.text = "0 kcal"
            self.proteinLabel?.text = "0 grams"
            self.carbsLabel?.text = "0 grams"
            self.fatsLabel?.text = "0 grams"
        }
    }
    
    func didUpdateInformation(with foodModel: FoodModel) {
        DispatchQueue.main.async {
            self.nameLabel.text = "\(foodModel.name) (100g)"
            self.caloriesLabel.text = "\(String(foodModel.calories)) kcal"
            
            if foodModel.protein != -1 {
                self.proteinLabel.text = "\(String(foodModel.protein)) grams"
            } else {
                self.proteinLabel.text = "Unknown"
            }
            
            if foodModel.carbs != -1 {
                self.carbsLabel.text = "\(String(foodModel.carbs)) grams"
            } else {
                self.carbsLabel.text = "Unknown"
            }
            
            if foodModel.fats != -1 {
                self.fatsLabel.text = "\(String(foodModel.fats)) grams"
            } else {
                self.fatsLabel.text = "Unknownr"
            }
            
        }
    }
}

