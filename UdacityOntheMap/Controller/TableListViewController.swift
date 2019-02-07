//
//  TableListViewController.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

class TableListViewController: UITableViewController {
    
    var studentDetails: [StudentPosition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayStudentLocations()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(studentDetails.count)
        return studentDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locations", for: indexPath)
        let location = studentDetails[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = "\(location.studentFirstName!) \(location.studentLastName!)"
        cell.detailTextLabel?.text = "\(location.studentURL)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationURL = studentDetails[indexPath.row].studentURL
        if locationURL.contains("http") {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapWebViewController") as! OnTheMapWebViewController
            viewController.urlString = studentDetails[indexPath.row].studentURL
            self.navigationController!.pushViewController(viewController, animated: true)
        } else {
            UdacityOntheMapClient.sharedInstance().displayError(error: "Invalid URL", "This does not appear to be a valid URL. Please try another student", self)
        }
    }
    
    //GET Student Locations
    
    func displayStudentLocations() {
        
         var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
         request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
         request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
         let session = URLSession.shared
         let task = session.dataTask(with: request) { data, response, error in
         guard error == nil else {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
         guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
         let parsedResult: [String:AnyObject]!
         do {
         parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
         } catch {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
         guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
         self.studentDetails = StudentPosition.studentPositionsFrom(results: results)
         performUIUpdatesOnMain {
         self.tableView.reloadData()
         }
         
         }
         task.resume()
        
    }
    
    //MARK: - Actions
    @IBAction func logoutApplication() {
        UdacityOntheMapClient.sharedInstance().getLogout(nameOfViewController:self)
    }

    
}

