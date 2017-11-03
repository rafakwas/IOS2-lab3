//
//  MasterViewController.swift
//  projekt2-test3
//
//  Created by Rafał on 30/10/2017.
//  Copyright © 2017 Rafał. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {


    var detailViewController: DetailTableViewController? = nil
    var objects = [[String:Any]]()
    
    func editObject(_ index : Int, _ newObject : [String:Any]) {
        objects[index] = newObject
        print("MasterViewController editObject for index \(index) and arist \(newObject["artist"])")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func removeObject(_ index : Int) {
        print("Object \(index) removed")
        objects.remove(at: index)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func initializeJson(withCompletion completion : @escaping (()->Void)) {
        let urlString = URL(string : "https://isebi.net/albums.php")
        let task = URLSession.shared.dataTask(with: urlString!) {data,response,error in
            self.objects = try! JSONSerialization.jsonObject(with : data!) as! [[String:Any]]
            completion()
        }
        print("initialize json")
        task.resume()
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        initializeJson(withCompletion: {
            print("json completed")
        });
        sleep(2)
        super.viewDidLoad()
        Linker.masterViewController = self
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailTableViewController
        }
    }
    @objc
    func insertNewObject(_ sender: Any) {
        var newObject = [String:Any]()
        newObject["artist"] = "Nowość"
        newObject["album"] = "Nowy album"
        newObject["genre"] = "Pop"
        newObject["tracks"] = 10
        newObject["year"] = 2017
        objects.insert(newObject, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    //    func addObject(_ newObject : [String:Any]) {
    //        objects.insert(newObject, at: 0)
    //        let indexPath = IndexPath(row: 0, section: 0)
    //        tableView.insertRows(at: [indexPath], with: .automatic)
    //    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailTableViewController
                let object = objects[indexPath.row]
                controller.detailItem = object
                controller.index = indexPath.row
                controller.all = objects.count
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView count \(objects.count)")
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView cell text")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        let year = object["year"] as! Int
        let artist = object["artist"] as! String
        let album = object["album"] as! String
        let textConcatenated = "\(artist)  \(album)  \(year)"
        cell.textLabel!.text = textConcatenated
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView editing/deleteing")
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    

}

