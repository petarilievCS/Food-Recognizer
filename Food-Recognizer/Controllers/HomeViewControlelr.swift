//
//  ViewController.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 16.1.23.
//

import UIKit
import AVFoundation

class HomeViewControlelr: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var camera : UIImagePickerController?
    var takenImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        camera = UIImagePickerController()
        camera?.delegate = self
        camera?.sourceType = .camera
    }
    
    // Present camera session when button pressed
    @IBAction func scanButtonPressed(_ sender: UIButton) {
    
        // Request camera access
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { permissionGranted in
            if permissionGranted {
                self.presentCamera()
            }
        })
        
    }
    
    // Create a camera session and present it to user
    func presentCamera() {
        guard let safeCamera = camera else {
            fatalError("Camera picker not initialized")
        }
        DispatchQueue.main.async {
            self.present(safeCamera, animated: true)
        }
    }
    
    // Use image to classify appropriate food
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            takenImage = image
            camera?.dismiss(animated: true)
            performSegue(withIdentifier: K.homeToInfoIdentifier, sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNC = segue.destination as! UINavigationController
        let destinationVC = destinationNC.viewControllers[0] as! FoodViewController
        destinationVC.image = takenImage!
    }
    
}

