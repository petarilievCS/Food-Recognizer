//
//  FoodViewController.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 16.1.23.
//

import UIKit

class FoodViewController: UIViewController {
    
    let cornerRadiusConstant: CGFloat = 10

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var proteinView: UIView!
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var fatsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        caloriesView.layer.cornerRadius = cornerRadiusConstant
        proteinView.layer.cornerRadius = cornerRadiusConstant
        carbsView.layer.cornerRadius = cornerRadiusConstant
        fatsView.layer.cornerRadius = cornerRadiusConstant
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
