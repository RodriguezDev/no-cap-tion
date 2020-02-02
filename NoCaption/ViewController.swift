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
        
        // Let the user submit items from either the camera or gallery.
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
    
    // Handler for when the image is picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            selectedImage = pickedImage
            
            // Update the UI to reflect the choice.
            chooseImageButton.loadingIndicator(true)
            subText.text = "Thanks chief."
            
            picker.dismiss(animated: true, completion: nil)
            
            let base64Image = pickedImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
            let params = ["image": base64Image] as Dictionary<String, String>
            
            var request = URLRequest(url: URL(string: "http://10.0.1.78:5000/api/v1/classify")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                
                do {
                    if error == nil {
                        // If we're successful, cool. Let's prepare to move on.
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        self.words = json["keywords"] as? NSArray
                        print(self.words ?? "")

                        self.completion(json: json)
                    } else {
                        self.errorHandler(message: "Looks like there was an issue.")
                    }
                } catch {
                    self.errorHandler(message: "Unable to connect to server.")
                    print("Error parsing JSON")
                }
            })

            task.resume()

        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWords" {
            let dvc = segue.destination as! WordSelectViewController
            
            // Pass the image and words up.
            if (selectedImage != nil) {
                dvc.userImage = selectedImage
            }
            dvc.givenWords = words
        }
    }
    
    // If the request is successful.
    func completion(json: Dictionary<String, AnyObject>) {
        DispatchQueue.main.async(){
           self.performSegue(withIdentifier: "showWords", sender: self)
        }
    }
    
    // If request is unsuccessful.
    func errorHandler(message: String) {
        DispatchQueue.main.async(){
            self.chooseImageButton.loadingIndicator(false)
            self.subText.text = message
        }
    }
}

