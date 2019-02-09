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
        return studentDetails.count
    }
    
    //MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locations", for: indexPath)
        let location = studentDetails[indexPath.row]
        // Putting values in the Cell...
        cell.textLabel?.text = "\(location.studentFirstName!) \(location.studentLastName!)"
        cell.detailTextLabel?.text = "\(location.studentURL)"
        return cell
    }
    
    //MARK: DidSelect Row.   Is customer Select the any ROW from the Table
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
    
    
    
    //MARK: displayStudentLocations  Display Student location as PIN using MKPointAnnotation
    func displayStudentLocations() {
        UdacityOntheMapClient.sharedInstance().getStudentLocations(self) { (student) in
            self.studentDetails = student
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func logoutApplication() {
        UdacityOntheMapClient.sharedInstance().getLogout(nameOfViewController:self)
    }

    
}

