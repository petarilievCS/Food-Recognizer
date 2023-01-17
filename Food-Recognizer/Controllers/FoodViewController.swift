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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var proteinView: UIView!
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var fatsView: UIView!
    
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
