//
//  ViewController.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 16.1.23.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
            takenImage = cropImageToSquare(image: image)
            camera?.dismiss(animated: true)
            
            // Clasiffy image
            let model = HomeViewController.createImageClassifier()
            
            // Create an image classification request with an image classifier model.
            let imageClassificationRequest = VNCoreMLRequest(model: model) { request, error in
                
            }
            imageClassificationRequest.imageCropAndScaleOption = .centerCrop
            
            let handler = VNImageRequestHandler(ciImage: CIImage(image: takenImage!)!)
            let requests: [VNRequest] = [imageClassificationRequest]

            // Start the image classification request.
            do {
                try handler.perform(requests)
            } catch {
                print("Error while performing request.")
            }
            
            performSegue(withIdentifier: K.homeToInfoIdentifier, sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNC = segue.destination as! UINavigationController
        let destinationVC = destinationNC.viewControllers[0] as! FoodViewController
        destinationVC.image = takenImage!
    }
    
    // Crops the taken image to a square
    func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)

        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2

        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }

        return nil
    }
    
    // MARK: - CoreML
    
    // Craetes a model that classifies images
    static func createImageClassifier() -> VNCoreMLModel {
        
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()
        
        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper = try? MobileNetV2(configuration: defaultConfig)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        // Get the underlying model instance.
        let imageClassifierModel = imageClassifier.model

        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }
    
}

