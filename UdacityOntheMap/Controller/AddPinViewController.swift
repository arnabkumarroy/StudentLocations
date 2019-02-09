//
//  AddPinViewController.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddPinViewController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let EMPTY = ""
    @IBOutlet weak var studentsPosition: UITextField!
    @IBOutlet weak var studentsShareURL: UITextField!
    @IBOutlet weak var mapViewKit: MKMapView!
    @IBOutlet weak var addDetailsButton: UIButton!
    @IBOutlet weak var showActivityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsPosition.delegate = self
        studentsShareURL.delegate = self
        mapViewKit.isHidden = true
        studentsPosition.isHidden = false
        studentsShareURL.isHidden = false
        addDetailsButton.isHidden = true
        showActivityIndicator.isHidden = true
    }
    
    @IBAction func performActiveGeocoding() {
        if studentsPosition.text != EMPTY && studentsShareURL.text != EMPTY {
            UdacityOntheMapClient.DUMMY_VALUES.mediaURL = studentsShareURL.text!
            UdacityOntheMapClient.DUMMY_VALUES.mapString = studentsPosition.text!
            showActivityIndicator.isHidden = false
            showActivityIndicator.startAnimating()
            let myLocation = self.studentsPosition.text
            let myGeoLocation = CLGeocoder()
            myGeoLocation.geocodeAddressString(myLocation!) { success, error in
                guard error == nil else {
                    UdacityOntheMapClient.sharedInstance().displayError(error: "You are not in Earth!!", "Please enter a location in Earth.", self)
                    return
                }
                guard let success = success?.first else {
                    UdacityOntheMapClient.sharedInstance().displayError(error: "You are not in Earth!!", "Please enter a location in Earth", self)
                    return
                }
                let mylocationCoordinate = success.location?.coordinate
                UdacityOntheMapClient.DUMMY_VALUES.latitude = mylocationCoordinate!.latitude
                UdacityOntheMapClient.DUMMY_VALUES.longitude = mylocationCoordinate!.longitude
                self.mapViewKit.isHidden = false
                self.studentsPosition.isHidden = true
                self.studentsShareURL.isHidden = true
                self.addDetailsButton.isHidden = false
                self.mapViewKit.addAnnotation(MKPlacemark(placemark: success))
                self.showActivityIndicator.stopAnimating()
                self.showActivityIndicator.isHidden = true
            }
        } else {
            UdacityOntheMapClient.sharedInstance().displayError(error: "Please give a full url. i.e. http", "else We will not be able to open the page", self)
        }
    }
    
    @IBAction func newLocationAdd() {
        UdacityOntheMapClient.sharedInstance().addMyAddress(self)
    }
    @IBAction func logoutApplication() {
        UdacityOntheMapClient.sharedInstance().getLogout(nameOfViewController: self)
    }
    @IBAction func cancel(){
        dismiss(animated: true, completion: nil)
    }
}

