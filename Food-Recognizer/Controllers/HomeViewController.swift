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
import AudioToolbox

protocol HomeViewControllerDelegate {
    func didUpdateInformation(with foodModel: FoodModel)
    func didNotDetectFood()
}

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var camera : UIImagePickerController?
    var takenImage: UIImage?
    var scannedItem: String?
    var apiManager: APIManager = APIManager()
    var delegate: HomeViewControllerDelegate?
    
    var calories: Double = 0
    var protein: Double = 0
    var carbs: Double = 0
    var fats: Double = 0
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiManager.delegate = self
        camera = UIImagePickerController()
        camera?.delegate = self
        camera?.sourceType = .photoLibrary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraIcon.tintColor = .white
    }
    
    // Present camera session when button pressed
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        cameraIcon.tintColor = .systemGray4
        
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
                
                if error != nil {
                    print("Error in classification: \(error!.localizedDescription)")
                } else {
                    guard let results = request.results as? [VNClassificationObservation] else {
                        fatalError("Error while accessing results")
                    }
                    if let firstResult = results.first {
                        let scannedItems = firstResult.identifier
                        let formattedName = self.formatResult(scannedItems).capitalized
                        self.scannedItem = formattedName
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: K.homeToInfoIdentifier, sender: self)
                            self.apiManager.performRequest(for: formattedName)
                        }
                        
                    }
                }
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
        }
        
    }
    
    // Formats result string in case where it contains more than one result
    func formatResult(_ result: String) -> String {
        if result.contains(",") {
            let position = result.firstIndex(of: ",")
            return String(result[result.startIndex..<position!])
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNC = segue.destination as! UINavigationController
        let destinationVC = destinationNC.viewControllers[0] as! FoodViewController
        destinationVC.image = takenImage!
        destinationVC.foodModel = FoodModel(name: scannedItem!, calories: calories, protein: protein, fats: fats, carbs: carbs)
        self.delegate = destinationVC
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

extension HomeViewController: APIManagerDelegate {
    
    func didNotDetectFood() {
        self.delegate?.didNotDetectFood()
    }
    
    func didUpdateInformation(foodModel: FoodModel) {
        calories = foodModel.calories
        protein = foodModel.protein
        carbs = foodModel.carbs
        fats = foodModel.fats
        self.delegate?.didUpdateInformation(with: foodModel)
    }
}


