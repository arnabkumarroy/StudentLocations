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
        UdacityOntheMapClient.DUMMY_VALUES.username = userDetailsField.text!
        UdacityOntheMapClient.DUMMY_VALUES.password = passwordField.text!
        UdacityOntheMapClient.sharedInstance().taskForLogin(self)
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
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

