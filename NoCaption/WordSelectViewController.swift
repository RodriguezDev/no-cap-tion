//
//  WordSelectViewController.swift
//  NoCaption
//
//  Created by Chris Rodriguez on 2/1/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit
import SpriteKit
import Magnetic

class WordSelectViewController: UIViewController, MagneticDelegate {
    
    // Variables for the Magnetic bubble scene.
    var magnetic: Magnetic?
    var counter = 0
    let MAX_WORDS = 5
    
    var userImage: UIImage!
    var givenWords: NSArray!
    var captions: NSArray!
    var IP: String!

    // MARK: Outlets
    @IBOutlet weak var bottomButtonVIew: UIView!
    @IBOutlet weak var addWordButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var magneticView: MagneticView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply designs
        //bottomButtonVIew.layer.cornerRadius = 20;
        addWordButton.applyDesign()
        
        // Initialize the "bubble" view
        magnetic = magneticView.magnetic
        magnetic?.magneticDelegate = self
        
        // Create the bubbles with the words given and set colors.
        for word in givenWords {
            let node = Node(text: (word as! String), image: UIImage(named: "chevron"), color: UIColor.colors[counter % UIColor.colors.count], radius: 45)
            magnetic!.addChild(node)
            counter += 1
        }
        
        continueButton.setTitle("", for: UIControl.State.disabled)
        
        // TODO: Consider if we want all pre-populated nodes to be selected, so continue will always be enabled by default
        if magnetic!.selectedChildren.count == 0 {
            continueButton.isEnabled = false
        }
    }
    
    // MARK: Actions
    // Adds a word to the list of words
    @IBAction func addWordTapped(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Word", message: "What should the caption be about?", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in }
        alert.addAction(cancel)

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if let enteredText = textField?.text, enteredText != "" {
                
                // Add the node with the given values and set a correct color for the node.
                self.magnetic!.addChild(Node(text: enteredText, image: UIImage(named: "chevron"), color: UIColor.colors[self.counter % UIColor.colors.count], radius: 45))
                
                self.counter += 1
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        
        // Create a list with the words from the selected bubbles.
        var words = [String]()
        
        for node in magnetic!.selectedChildren {
            let text: String = node.text!
            words += [text]
        }
        
        print(words)
        continueButton.loadingIndicator(true)
        
        let params = ["keywords": words] as Dictionary<String, [String]>
        print(words)
        
        var request = URLRequest(url: URL(string: "http://" + IP + ":5000/api/v1/findlyric")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                if error == nil {
                    // Even better. Let's get ready for the final segue.
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    self.captions = (json["captions"] as! NSArray)

                    self.completion(json: json)
                } else {
                    self.errorHandler(message: "Looks like there was an error.")
                }
            } catch {
                self.errorHandler(message: "Unable to connect to server.")
                print("Error parsing JSON")
            }
        })

        task.resume()
    }
    
    // MARK: Magnetic methods
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        continueButton.isEnabled = true
        // If the user selects a node when we're at capacity, uncheck it right after. Sneaky.
        if magnetic.selectedChildren.count > MAX_WORDS {
            node.isSelected = false
        }
    }

    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        // If no options are selected, hide the continue button.
        if magnetic.selectedChildren.count == 0 {
            continueButton.isEnabled = false
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageReview" {
            let dvc = segue.destination as! ImageReviewViewController
            dvc.userImage = userImage
        }
        if segue.identifier == "toResults" {
            let dvc = segue.destination as! ResultsViewController
            dvc.image = userImage
            
            var words = [String]()
            for selected in magnetic!.selectedChildren {
                words.append(selected.text!)
            }
            
            dvc.words = words
            dvc.captions = (captions as! [Any])
        }
    }
    
    // MARK: Completion handlers for post request.
    // If successful.
    func completion(json: Dictionary<String, AnyObject>) {
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "toResults", sender: self)
        }
    }
    
    // If unsuccessful.
    func errorHandler(message: String) {
        DispatchQueue.main.async(){
            self.continueButton.loadingIndicator(false)
        }
    }
}
