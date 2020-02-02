//
//  ImageReviewViewController.swift
//  NoCaption
//
//  Created by Chris Rodriguez on 2/1/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class ImageReviewViewController: UIViewController {

    var userImage: UIImage!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var bottomButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //bottomButtonView.layer.cornerRadius = 20;
        imageOutlet.image = userImage
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
