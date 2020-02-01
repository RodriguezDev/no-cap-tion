//
//  ViewController.swift
//  NoCaption
//
//  Created by Chris Rodriguez on 1/31/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply designs
        chooseImageButton.applyDesign()
    }

    // MARK: Actions
    @IBAction func chooseImage(_ sender: Any) {
        
    }
    
}

