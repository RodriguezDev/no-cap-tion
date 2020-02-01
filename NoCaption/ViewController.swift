//
//  ViewController.swift
//  NoCaption
//
//  Created by Chris Rodriguez on 1/31/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var words: NSArray?
    
    // MARK: Outlets
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var subText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply designs
        chooseImageButton.applyDesign()
    }

    // MARK: Actions
    @IBAction func chooseImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:-- ImagePicker Code
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            //logoImage.contentMode = .scaleToFill
            
            selectedImage = pickedImage
            
            chooseImageButton.loadingIndicator(true)
            subText.text = "Thanks chief."
            let base64Image = pickedImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
            
            picker.dismiss(animated: true, completion: nil)
            
            // Local IP: 169.234.114.44
            let params = ["image": base64Image] as Dictionary<String, String>
            
            var request = URLRequest(url: URL(string: "http://169.234.114.44:5000/api/v1/classify")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    self.words = json["keywords"] as? NSArray
                    print(self.words ?? "")

                    self.completion(json: json)
                } catch {
                    self.errorHandler(message: "Unable to connect to server.")
                    print("Error parsing JSON")
                }
            })

            task.resume()
            
//            // TODO: delete this trash.
//            let seconds = 2.0
//            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//                // Put your code which should be executed with a delay here
//                self.performSegue(withIdentifier: "showWords", sender: self)
//            }
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWords" {
            let dvc = segue.destination as! WordSelectViewController
            
            if (selectedImage != nil) {
                dvc.userImage = selectedImage
            }
            
            dvc.givenWords = words
        }
    }
    
    // If successful signup.
    func completion(json: Dictionary<String, AnyObject>) {
        DispatchQueue.main.async(){
           self.performSegue(withIdentifier: "showWords", sender: self)
        }
    }
    
    // If signup is unsuccessful.
    func errorHandler(message: String) {
        DispatchQueue.main.async(){
            
        }
    }
}

