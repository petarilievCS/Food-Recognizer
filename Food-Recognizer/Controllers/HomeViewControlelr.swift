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
    
}

