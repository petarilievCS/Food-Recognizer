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
    @IBOutlet weak var tableView: UITableView!
    
    var calories: Int = 0
    var protein: Int = 0
    var carbs: Int = 0
    var fats: Int = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gramsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        tableView.layer.cornerRadius = cornerRadiusConstant
        gramsLabel.isHidden = true
        
        // Set image if present
        if let safeImage = image {
            imageView.image = safeImage
        }
    }
}

extension FoodViewController: HomeViewControllerDelegate {
    
    func didNotDetectFood() {
        DispatchQueue.main.async {
            self.nameLabel?.text = "No Food Detected"
            self.calories = 0
            self.protein = 0
            self.fats = 0
            self.carbs = 0
            if let safeTableView = self.tableView {
                safeTableView.reloadData()
            }
        }
    }
    
    func didUpdateInformation(with foodModel: FoodModel) {
        DispatchQueue.main.async {
            if self.nameLabel != nil {
                self.nameLabel?.text = "\(foodModel.name)"
                self.gramsLabel?.isHidden = false
                self.calories = Int(foodModel.calories)
                self.protein = Int(foodModel.protein)
                self.carbs = Int(foodModel.carbs)
                self.fats = Int(foodModel.fats)
                self.tableView?.reloadData()
            } else {
                self.didUpdateInformation(with: foodModel)
            }
        }
    }
}

// MARK: - TableView methods

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutrientCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Energy"
            cell.detailTextLabel?.text = calories != -1 ? "\(calories) KCAL" : "Unknown"
        case 1:
            cell.textLabel?.text = "Protein"
            cell.detailTextLabel?.text = protein != -1 ? "\(protein) G" : "Unknown"
        case 2:
            cell.textLabel?.text = "Carbs"
            cell.detailTextLabel?.text = carbs != -1 ? "\(carbs) G" : "Unknown"
        default:
            cell.textLabel?.text = "Fats"
            cell.detailTextLabel?.text = fats != -1 ? "\(fats) G" : "Unknown"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
