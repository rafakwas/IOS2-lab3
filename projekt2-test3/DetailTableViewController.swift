//
//  DetailViewController.swift
//  projekt2-test3
//
//  Created by Rafał on 30/10/2017.
//  Copyright © 2017 Rafał. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
 
    
    
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var albumCellText: UITextField!
    @IBOutlet var artistCellText: UITextField!
    @IBOutlet var genreCellText: UITextField!
    @IBOutlet var tracksCellText: UITextField!
    @IBOutlet var yearCellText: UITextField!
    @IBOutlet var saveButton: UIButton!

    var detailItem = [String:Any]()
    var index : Int = 0
    var all : Int = 0
    
    
    @IBAction func onEditEnd(_ sender: Any) {
        saveButton.isEnabled = true
        detailItem["album"] = albumCellText.text!;
        detailItem["artist"] = artistCellText.text!;
        detailItem["genre"] = genreCellText.text!;
        detailItem["tracks"] = Int(tracksCellText.text!);
        detailItem["year"] = Int(yearCellText.text!);
        print("onEditEnd: \(detailItem["artist"])")
    }
    
    
    @IBAction func onSaveClicked(_ sender: Any) {
        saveButton.isEnabled = false
        print("onSaveClicked for index \(index) and arist \(detailItem["artist"])")
        Linker.masterViewController!.editObject(index, detailItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let removeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(removeObject(_:)))
        navigationItem.rightBarButtonItem = removeButton
        
        let album = detailItem["album"] as! String
        let artist = detailItem["artist"] as! String
        let genre = detailItem["genre"] as! String
        let tracks = detailItem["tracks"] as! Int
        let year = detailItem["year"] as! Int
        albumCellText.text = album
        artistCellText.text = artist
        genreCellText.text = genre
        yearCellText.text = "\(year)"
        tracksCellText.text = "\(tracks)"
        recordLabel.text = "Rekord \(index+1) z \(all)"
        saveButton.isEnabled = false
   }
    
    @objc
    func removeObject(_ sender: Any) {
        Linker.masterViewController!.removeObject(index)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

}

