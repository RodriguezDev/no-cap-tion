//
//  ResultsViewController.swift
//  NoCaption
//
//  Created by Chris Rodriguez on 2/1/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var words: [String]!
    var image: UIImage!
    
    // MARK: Outlets
    @IBOutlet weak var restartButtonOutlet: UIButton!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var resultsTable: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restartButtonOutlet.applyDesign()
        // Do any additional setup after loading the view.
        
        imageOutlet.image = image
        
        let joiner = ", "
        let joinedString = words.joined(separator: joiner)
        wordLabel.text = "For: " + joinedString
    }
    
    // MARK: Table View handlers
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableViewCell
        
        cell.lyricLabel.text = "Some lyrics"
        cell.artistLabel.text = "Some artist"
        cell.albumLabel.text = "Some almub"
        
        return cell
    }
}
