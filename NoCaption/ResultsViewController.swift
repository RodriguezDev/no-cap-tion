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
    var captions: [Any]!
    
    // MARK: Outlets
    @IBOutlet weak var restartButtonOutlet: UIButton!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOutlet.maskCircle(anyImage: image)
        
        print(captions!)
        
        // Create the string of the selected words.
        let joiner = ", "
        let joinedString = words.joined(separator: joiner)
        wordLabel.text = "For: " + joinedString
        
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
        self.resultsTableView.allowsSelection = false
        
        // Let users tap on the image to view it larger in another view controller.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResultsViewController.cellTappedMethod(_:)))
        
        imageOutlet.isUserInteractionEnabled = true
        imageOutlet.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        self.performSegue(withIdentifier: "toImageView", sender: self)
    }
    
    // MARK: Table View handlers
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captions.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableViewCell
        
        let json = captions![indexPath.row] as! [String: String]
        
        // Fill in the cell with the recieved JSON data.
        cell.lyricLabel.text = "\"" + json["lyric"]!.trim() + "\""
        cell.songLabel.text = json["song"]!.trim()
        cell.artistLabel.text = json["artist"]!.trim()
        
        return cell
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageView" {
            let dvc = segue.destination as! ImageReviewViewController
            dvc.userImage = image
        }
    }
}
