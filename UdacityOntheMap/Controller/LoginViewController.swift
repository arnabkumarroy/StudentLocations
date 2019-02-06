//
//  LoginViewController.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userDetailsField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailsField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func StudentLogin() {
        if userDetailsField.text == "" || passwordField.text == "" {
            UdacityOntheMapClient.sharedInstance().displayError(error: " Either Email or Password is missing", "Please enter the Details Correctly", self)
            return
        }
        UdacityOntheMapClient.HTTPBodyValues.username = userDetailsField.text!
        UdacityOntheMapClient.HTTPBodyValues.password = passwordField.text!
        UdacityOntheMapClient.sharedInstance().taskForLogin(self)
        /*
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body  = ["udacity": [
            "username": userDetailsField.text!,
            "password": passwordField.text!
            ]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 599 else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            if statusCode >= 300 && statusCode <= 399 {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            } else if statusCode >= 400 && statusCode <= 499 {
                self.displayError(error: "Invalid Credentials", "Please check your email and password are correct and try again")
                return
            } else if statusCode >= 500 {
                self.displayError(error: "Unable to Connect", "Please check your network connection and try again")
                return
            }
            let range = Range(5..<data!.count)
            let result = data?.subdata(in: range)
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            guard let accountInfo = parsedResult["account"] as? [String:AnyObject] else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            guard let isRegistered = accountInfo["registered"] as? Bool else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            if isRegistered {
                performUIUpdatesOnMain {
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
            }
        }
        task.resume()
        */
        
    }
    
    //MARK: - Text Field Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Error Functions
    
    func displayError(error: String, _ description: String) {
        print(error)
        let alert = UIAlertController(title: error, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

