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
    
    var magnetic: Magnetic?
    var counter = 0
    let MAX_WORDS = 5

    // MARK: Outlets
    @IBOutlet weak var bottomButtonVIew: UIView!
    @IBOutlet weak var magneticView: MagneticView!
    @IBOutlet weak var addWordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply designs
        bottomButtonVIew.layer.cornerRadius = 20;
        addWordButton.applyDesign()
        
        // Initialize the "bubble" view
        magnetic = magneticView.magnetic
        magnetic?.magneticDelegate = self
        
        for _ in 1...10 {
            let node = Node(text: "Word", image: UIImage(named: "chevron"), color: UIColor.colors[counter % UIColor.colors.count], radius: 30)
            magnetic!.addChild(node)
            counter += 1
        }
    }
    
    // MARK: Actions
    // Adds a word to the list of words
    @IBAction func addWordTapped(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add a Word", message: "What should a the caption be about?", preferredStyle: .alert)

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
                self.magnetic!.addChild(Node(text: enteredText, image: UIImage(named: "chevron"), color: UIColor.colors[self.counter % UIColor.colors.count], radius: 30))
                
                self.counter += 1
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        for node in magnetic!.selectedChildren {
            print(node.text!)
        }
    }
    
    // MARK: Magnetic methods
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        // If the user selects a node when we're at capacity, uncheck it right after. Sneaky.
        if magnetic.selectedChildren.count > MAX_WORDS {
            node.isSelected = false
        }
    }

    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
    }
}
