//
//  CameraViewController.swift
//  fakestagram
//
//  Created by Andrès Leal Giorguli on 5/25/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    
    let locationManager = CLLocationManager()
    let client = CreatePostClient()
    var currentLocation: CLLocation?
    var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBasicLocationServices()
        btnCapture.isHidden = true
        btnPhoto.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnPhoto.layer.borderWidth = 2.0
        btnPhoto.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onTapCapture(_ sender: Any) {
        print("posting....")
        createPost(img: img ?? UIImage(named: "longcat space")!)
    }
    
    func enableBasicLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Disable location features")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Enable location features")
        }
    }
    
    func createPost(img: UIImage) {
        guard let imgBase64 = img.encodedBase64() else { return }
        let timestamp = Date().currentTimestamp()
        client.create(title: String(timestamp), imageData: imgBase64, location: currentLocation) { post in
            print(post)
        }
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        
        showAlertPhoto()
        
    }
    
    
}

extension CameraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showAlertPhoto() {
        
        let alert = UIAlertController(title: "Opciones", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Gallería", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageViewPhoto.image = image
        img = image
        btnCapture.isHidden = false
        btnPhoto.isHidden = true
        picker.dismiss(animated: true, completion: nil)
    }
}
// 1565284409539
